//
//  MusicPlayerClient.swift
//  MusicPlayer
//
//  Created by Hong Seong Ho on 12/27/24.
//

import Foundation
import Dependencies
import TCAExamEntities
import MusicPlayerManager

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
        play: { MusicPlayerManager.shared.play() },
        pause: { MusicPlayerManager.shared.pause() },
        startAlbum: { musicList, index in MusicPlayerManager.shared.startPlay(musicList: musicList, index: index) },
        nextPlay: { MusicPlayerManager.shared.nextPlay() },
        prevPlay: { MusicPlayerManager.shared.prevPlay() },
        currentMusic: {
            AsyncStream { continuation in
                let musicPlayerManager = MusicPlayerManager.shared
                Task { await musicPlayerManager.configureCurrentMusicContinuation(continuation) }
            }
        },
        playingState: {
            AsyncStream { continuation in
                let musicPlayerManager = MusicPlayerManager.shared
                Task { await musicPlayerManager.configurePlayingStateContinuation(continuation) }
            }
        }
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
