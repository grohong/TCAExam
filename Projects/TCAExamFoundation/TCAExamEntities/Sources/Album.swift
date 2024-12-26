//
//  Album.swift
//
//
//  Created by Hong Seong Ho on 3/31/24.
//

import Foundation

public struct Album: Identifiable, Equatable {

    public let id: UUID
    public let title: String
    public let artist: String
    public let musicList: [Music]

    public init(id: UUID, title: String, artist: String, musicList: [Music]) {
        self.id = id
        self.title = title
        self.artist = artist
        self.musicList = musicList
    }
}
