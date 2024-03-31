//
//  Album.swift
//
//
//  Created by Hong Seong Ho on 3/31/24.
//

import Foundation

public struct Album: Identifiable {

    public let id: UUID
    public let title: String
    public let artist: String
    public let musicList: [Music]
}
