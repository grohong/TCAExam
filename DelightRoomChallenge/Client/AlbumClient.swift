//
//  AlbumClient.swift
//  DelightRoomChallenge
//
//  Created by Hong Seong Ho on 3/31/24.
//

import Foundation
import Dependencies
import Entities

struct AlbumClient {

    var fetchAlbumList: () async -> [Album]
}

extension AlbumClient: DependencyKey {

    static let liveValue = Self(
        fetchAlbumList: { Album.mockAlbumList }
    )
}

extension DependencyValues {

    var albumClient: AlbumClient {
        get { self[AlbumClient.self] }
        set { self[AlbumClient.self] = newValue }
    }
}
