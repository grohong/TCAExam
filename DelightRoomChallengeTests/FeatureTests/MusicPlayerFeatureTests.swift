//
//  MusicPlayerFeatureTests.swift
//  DelightRoomChallengeTests
//
//  Created by Hong Seong Ho on 4/2/24.
//

import XCTest
@testable import DelightRoomChallenge
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
    func testPause() async {
        let store = TestStore(initialState: MusicPlayerFeature.State()) {
            MusicPlayerFeature()
        }

        await store.send(.pause)
        await store.receive(.isPlayingChanged(false)) {
            $0.isPlaying = false
        }
    }

    @MainActor
    func testPlay() async {
        let store = TestStore(initialState: MusicPlayerFeature.State(isPlaying: false)) {
            MusicPlayerFeature()
        }

        await store.send(.play)
        await store.receive(.isPlayingChanged(true)) {
            $0.isPlaying = true
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
            period: { AsyncStream { _ in } }
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
            period: { AsyncStream { _ in } }
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
    func testSycnPeriod() async {
        let periodContinuation = PeriodContinuationManager()

        let mockMusicPlayerClient = MusicPlayerClient(
            play: { },
            pause: { },
            startAlbum: { musicList, index in },
            nextPlay: { },
            prevPlay: { },
            currentMusic: { AsyncStream { continuation in } },
            period: {
                AsyncStream { continuation in
                    Task { await periodContinuation.configure(continuation) }
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
        await periodContinuation.yield(period: 0.5)
        await store.receive(.periodChanged(0.5)) {
            $0.period = 0.5
        }
    }
}

actor PeriodContinuationManager {

    var continuation: AsyncStream<Double>.Continuation?

    func yield(period: Double) {
        continuation?.yield(period)
    }

    func configure(_ continuation: AsyncStream<Double>.Continuation) {
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
