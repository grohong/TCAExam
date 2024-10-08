//
//  MusicPlayerFeatureTests.swift
//  TCAExamTests
//
//  Created by Hong Seong Ho on 4/2/24.
//

import XCTest
@testable import TCAExam
import ComposableArchitecture
import Entities

final class MusicPlayerFeatureTests: XCTestCase {

    @MainActor
    func testShowSheet() async {
        let store = TestStore(initialState: MusicPlayerFeature.State()) {
            MusicPlayerFeature()
        }

        await store.send(.showSheet) {
            $0.isSheetPresented = true
        }
    }

    @MainActor
    func testHideSheet() async {
        let store = TestStore(initialState: MusicPlayerFeature.State(isSheetPresented: true)) {
            MusicPlayerFeature()
        }

        await store.send(.hideSheet) {
            $0.isSheetPresented = false
        }
    }

    @MainActor
    func testNextPlay() async {

        let indexer = MusicIndexer()

        let mockMusicPlayerClient = MusicPlayerClient(
            play: { },
            pause: { },
            startAlbum: { _, _ in },
            nextPlay: { await indexer.incrementIndex() },
            prevPlay: { },
            currentMusic: { AsyncStream { _ in } },
            playingState: { AsyncStream { _ in } }
        )

        let store = TestStore(initialState: MusicPlayerFeature.State()) {
            MusicPlayerFeature()
        } withDependencies: {
            $0.musicPlayerClient = mockMusicPlayerClient
        }

        await store.send(.nextPlay)
        let nextPlayIndex = await indexer.index
        XCTAssertEqual(nextPlayIndex, 1)
    }

    @MainActor
    func testPrevPlay() async {

        let indexer = MusicIndexer()

        let mockMusicPlayerClient = MusicPlayerClient(
            play: { },
            pause: { },
            startAlbum: { _, _ in },
            nextPlay: { },
            prevPlay: { await indexer.decrementIndex() },
            currentMusic: { AsyncStream { _ in } },
            playingState: { AsyncStream { _ in } }
        )

        let store = TestStore(initialState: MusicPlayerFeature.State()) {
            MusicPlayerFeature()
        } withDependencies: {
            $0.musicPlayerClient = mockMusicPlayerClient
        }

        await store.send(.prevPlay)
        let prevPlayIndex = await indexer.index
        XCTAssertEqual(prevPlayIndex, -1)
    }

    @MainActor
    func testSycnPlayingState() async {
        let playingStateContinuationManager = PlayingStateContinuationManager()

        let mockMusicPlayerClient = MusicPlayerClient(
            play: { },
            pause: { },
            startAlbum: { musicList, index in },
            nextPlay: { },
            prevPlay: { },
            currentMusic: { AsyncStream { continuation in } },
            playingState: {
                AsyncStream { continuation in
                    Task { await playingStateContinuationManager.configure(continuation) }
                }
            }
        )

        let store = TestStore(initialState: MusicPlayerFeature.State()) {
            MusicPlayerFeature()
        } withDependencies: {
            $0.musicPlayerClient = mockMusicPlayerClient
        }

        store.exhaustivity = .off(showSkippedAssertions: false)
        await store.send(.onTask)
        let changedPlayingState = PlayingState(isPlaying: false, currentTimeInSeconds: 0.4, durationInSeconds: 0.6)
        await playingStateContinuationManager.yield(playingState: changedPlayingState)
        await store.receive(.playStateChanged(changedPlayingState)) {
            $0.playingState = changedPlayingState
        }
    }
}

actor PlayingStateContinuationManager {

    var continuation: AsyncStream<PlayingState>.Continuation?

    func yield(playingState: PlayingState) {
        continuation?.yield(playingState)
    }

    func configure(_ continuation: AsyncStream<PlayingState>.Continuation) {
        self.continuation = continuation
    }
}

actor MusicIndexer {

    var index: Int = .zero

    func incrementIndex() {
        index += 1
    }

    func decrementIndex() {
        index -= 1
    }
}
