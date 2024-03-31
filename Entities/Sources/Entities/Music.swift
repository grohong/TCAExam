//
//  Music.swift
//
//
//  Created by Hong Seong Ho on 3/31/24.
//

import AVFoundation

public struct Music: Equatable, Identifiable, Codable {

    public let id: UUID
    public let title: String
    public let artist: String
    public let assetURL: URL

    public var asset: AVAsset? {
        AVAsset(url: assetURL)
    }
}
