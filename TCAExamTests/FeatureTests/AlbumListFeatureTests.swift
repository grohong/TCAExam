//
//  AlbumListFeatureTests.swift
//  TCAExamTests
//
//  Created by Hong Seong Ho on 4/1/24.
//

import XCTest
@testable import TCAExam
import ComposableArchitecture
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
