//
//  AlbumClient.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 3/31/24.
//

import Foundation
import MediaPlayer
import Dependencies
import Entities

struct AlbumClient {

    var fetchAlbumList: () async -> [Album]
}

extension AlbumClient: DependencyKey {

    static let liveValue = Self(
        fetchAlbumList: {
            let status = await withUnsafeContinuation { continuation in
                MPMediaLibrary.requestAuthorization { status in
                    continuation.resume(with: .success(status))
                }
            }

            guard status == .authorized else { return Album.mockAlbumList }

            let predicate = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
            let query = MPMediaQuery.songs()
            query.addFilterPredicate(predicate)
            guard let mediaItemList = query.items else { return [] }

            let albumsDictionary = Dictionary(grouping: mediaItemList) { $0.albumTitle ?? "Unknown Album" }

            return albumsDictionary.compactMap { albumTitle, items in
                guard let firstItem = items.first, let artist = firstItem.albumArtist else { return nil }

                let musicList: [Music] = items.compactMap { item in
                    guard let title = item.title, let assetURL = item.assetURL else { return nil }
                    return Music(id: UUID(), title: title, artist: artist, assetURL: assetURL)
                }

                return musicList.isEmpty ? nil : Album(id: UUID(), title: albumTitle, artist: artist, musicList: musicList)
            }
        }
    )

    static let previewValue = Self(
        fetchAlbumList: { Album.mockAlbumList }
    )

    static let testValue = Self(
        fetchAlbumList: { Album.mockAlbumList }
    )
}

extension DependencyValues {

    var albumClient: AlbumClient {
        get { self[AlbumClient.self] }
        set { self[AlbumClient.self] = newValue }
    }
}
