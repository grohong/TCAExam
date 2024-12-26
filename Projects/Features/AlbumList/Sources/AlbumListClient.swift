//
//  AlbumListClient.swift
//  AlbumList
//
//  Created by Hong Seong Ho on 12/26/24.
//

import Foundation
import MediaPlayer
import Dependencies
import TCAExamEntities

public struct AlbumListClient: Sendable {

    var fetchAlbumList: @Sendable () async -> [Album]
}

extension AlbumListClient: DependencyKey {

    public static let liveValue = Self(
        fetchAlbumList: {
            let status = await withUnsafeContinuation { continuation in
                MPMediaLibrary.requestAuthorization { status in
                    continuation.resume(with: .success(status))
                }
            }

            guard status == .authorized else { return [] }

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
}

extension DependencyValues {

    var albumListClient: AlbumListClient {
        get { self[AlbumListClient.self] }
        set { self[AlbumListClient.self] = newValue }
    }
}
