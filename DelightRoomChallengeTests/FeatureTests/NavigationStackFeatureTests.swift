//
//  NavigationStackFeatureTests.swift
//  DelightRoomChallengeTests
//
//  Created by Hong Seong Ho on 4/1/24.
//

import XCTest
@testable import DelightRoomChallenge
import ComposableArchitecture
import Entities

final class NavigationStackFeatureTests: XCTestCase {

    @MainActor
    func testAlbumNavigation() async {
        let store = TestStore(initialState: NavigationStackFeature.State()) {
            NavigationStackFeature()
        }

        let mockAlbum = Album.mockAlbumList.first!
        await store.send(.path(.push(id: 0, state: .album(AlbumFeature.State(album: mockAlbum))))) {
            $0.path[id: 0] = .album(AlbumFeature.State(album: mockAlbum))
        }
    }
}
