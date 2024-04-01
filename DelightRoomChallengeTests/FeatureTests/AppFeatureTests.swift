//
//  AppFeatureTests.swift
//  DelightRoomChallengeTests
//
//  Created by Hong Seong Ho on 4/2/24.
//

import XCTest
@testable import DelightRoomChallenge
import ComposableArchitecture
import Entities

final class AppFeatureTests: XCTestCase {

    @MainActor
    func testCurrentMusicChanged() async {
        let mockMusic = Music(id: UUID(), title: "Song 1", artist: "Artist 1", assetURL: URL(string: "https://example.com/1.mp3")!)

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }

        await store.send(.currentMusicChanged(mockMusic)) {
            $0.musicPlayer = MusicPlayerFeature.State(music: mockMusic)
        }
    }

    @MainActor
    func testCurrentMusicChangedWhenHasOrigin() async {
        let originMusic = Music(id: UUID(), title: "Song 1", artist: "Artist 1", assetURL: URL(string: "https://example.com/1.mp3")!)
        let chagnedMusic = Music(id: UUID(), title: "Song 2", artist: "Artist 2", assetURL: URL(string: "https://example.com/2.mp3")!)

        let store = TestStore(initialState: AppFeature.State(
            musicPlayer: MusicPlayerFeature.State(music: originMusic)
        )) {
            AppFeature()
        }

        await store.send(.currentMusicChanged(chagnedMusic)) {
            $0.musicPlayer = MusicPlayerFeature.State(music: chagnedMusic)
        }
    }

    @MainActor
    func testCurrentMusicChangedWhenNil() async {
        let originMusic = Music(id: UUID(), title: "Song 1", artist: "Artist 1", assetURL: URL(string: "https://example.com/1.mp3")!)

        let store = TestStore(initialState: AppFeature.State(
            musicPlayer: MusicPlayerFeature.State(music: originMusic)
        )) {
            AppFeature()
        }

        await store.send(.currentMusicChanged(nil)) {
            $0.musicPlayer = nil
        }
    }

    @MainActor
    func testPlayAblumInAlumAction() async {
        let dummyMusicList = [
            Music(id: UUID(), title: "Song 1", artist: "Artist 1", assetURL: URL(string: "https://example.com/1.mp3")!),
            Music(id: UUID(), title: "Song 2", artist: "Artist 1", assetURL: URL(string: "https://example.com/2.mp3")!),
            Music(id: UUID(), title: "Song 2", artist: "Artist 1", assetURL: URL(string: "https://example.com/2.mp3")!),
            Music(id: UUID(), title: "Song 2", artist: "Artist 1", assetURL: URL(string: "https://example.com/2.mp3")!)
        ]
        let mockAlbum = Album(id: UUID(), title: "album title", artist: "Artist 1", musicList: dummyMusicList)
        let startIndex: Int = .zero

        let currentMusicContinuation = CurrentMusicContinuationManager()

        let musicPlayerClient = MusicPlayerClient(
            play: { },
            pause: { },
            startAlbum: { musicList, index in
                await currentMusicContinuation.yield(music: musicList[index])
            },
            nextPlay: { },
            prevPlay: { },
            currentMusic: {
                AsyncStream { continuation in
                    Task { await currentMusicContinuation.configure(continuation) }
                }
            },
            period: { AsyncStream { continuation in } }
        )

        let store = TestStore(
            initialState: AppFeature.State(
                navigationStack: NavigationStackFeature.State(
                    path: StackState([.album(AlbumFeature.State(album: mockAlbum))])
                )
            )
        ) {
            AppFeature()
        } withDependencies: {
            $0.musicPlayerClient = musicPlayerClient
        }

        store.exhaustivity = .off(showSkippedAssertions: false)
        await store.send(.onTask)
        await store.send(.navigationStack(.path(.element(id: 0, action: .album(.delegate(.playAlbum(album: mockAlbum, startIndex: startIndex)))))))
        await store.receive(.currentMusicChanged(dummyMusicList[startIndex])) {
            $0.musicPlayer = MusicPlayerFeature.State(music: dummyMusicList[startIndex])
        }
    }
}

actor CurrentMusicContinuationManager {

    var continuation: AsyncStream<Music?>.Continuation?

    func yield(music: Music?) {
        continuation?.yield(music)
    }

    func configure(_ continuation: AsyncStream<Music?>.Continuation) {
        self.continuation = continuation
    }
}
