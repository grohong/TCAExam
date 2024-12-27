//
//  MusicPlayerClient.swift
//  MusicPlayer
//
//  Created by Hong Seong Ho on 12/27/24.
//

import Foundation
import Dependencies
import TCAExamEntities

struct MusicPlayerClient {

    var play: @Sendable () async -> Void
    var pause: @Sendable () async -> Void
    var startAlbum: @Sendable (([Music], Int)) async -> Void
    var nextPlay: @Sendable () async -> Void
    var prevPlay: @Sendable () async -> Void
    var currentMusic: @Sendable () -> AsyncStream<Music?>
    var playingState: @Sendable () -> AsyncStream<PlayingState>
}

extension MusicPlayerClient: DependencyKey {

    static let liveValue = Self(
        play: { },
        pause: { },
        startAlbum: { musicList, index in },
        nextPlay: { },
        prevPlay: { },
        currentMusic: { AsyncStream { continuation in } },
        playingState: { AsyncStream { continuation in } }
    )

    static let testValue = Self(
        play: { },
        pause: { },
        startAlbum: { musicList, index in },
        nextPlay: { },
        prevPlay: { },
        currentMusic: { AsyncStream { continuation in } },
        playingState: { AsyncStream { continuation in } }
    )
}

extension DependencyValues {

    var musicPlayerClient: MusicPlayerClient {
        get { self[MusicPlayerClient.self] }
        set { self[MusicPlayerClient.self] = newValue }
    }
}
