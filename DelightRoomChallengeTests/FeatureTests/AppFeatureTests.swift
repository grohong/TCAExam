//
//  AppFeatureTests.swift
//  DelightRoomChallengeTests
//
//  Created by Hong Seong Ho on 4/1/24.
//

import XCTest
@testable import DelightRoomChallenge
import ComposableArchitecture
import Entities

final class AppFeatureTests: XCTestCase {

    @MainActor
    func testAlbumNavigation() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }

        let mockAlbum = Album.mockAlbumList.first!
        await store.send(.path(.push(id: 0, state: .album(AlbumFeature.State(album: mockAlbum))))) {
            $0.path[id: 0] = .album(AlbumFeature.State(album: mockAlbum))
        }
    }

    @MainActor
    func testPlayAlbum() async {
        let mockAlbum = Album.mockAlbumList.first!
        let startIndex: Int = .zero
        let store = TestStore(
            initialState: AppFeature.State(
                path: StackState([.album(AlbumFeature.State(album: mockAlbum))])
            )
        ) {
            AppFeature()
        }

        await store.send(.path(.element(id: 0, action: .album(.delegate(.playAlbum(album: mockAlbum, startIndex: startIndex)))))) {
            $0.playAlbum = mockAlbum
            $0.albumIndex = startIndex
        }
    }
}
