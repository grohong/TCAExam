//
//  MusicPlayerClient.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 4/2/24.
//

import Foundation
import Dependencies
import Entities
import MusicPlayer

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
        play: { await MusicPlayerManager.shared.play() },
        pause: { await MusicPlayerManager.shared.pause() },
        startAlbum: { musicList, index in await MusicPlayerManager.shared.startPlay(musicList: musicList, index: index) },
        nextPlay: { await MusicPlayerManager.shared.nextPlay() },
        prevPlay: { await MusicPlayerManager.shared.prevPlay() },
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
