//
//  AlbumListFeatureTests.swift
//  DelightRoomChallengeTests
//
//  Created by Hong Seong Ho on 4/1/24.
//

import ComposableArchitecture
import XCTest
@testable import DelightRoomChallenge
import Entities

final class AlbumListFeatureTests: XCTestCase {

    @MainActor
    func testFetchAlbum() async {
        let mockList = Album.mockAlbumList
        let store = TestStore(initialState: AlbumListFeature.State()) {
            AlbumListFeature()
        } withDependencies: {
            $0.albumClient = .init(
                fetchAlbumList: { mockList }
            )
        }

        await store.send(.fetchAblumList)
        await store.receive(.albumList(mockList)) {
            $0.albumList = mockList
        }
    }
}
