//
//  AlbumListTests.swift
//  TCAExamTests
//
//  Created by Hong Seong Ho on 4/1/24.
//

import XCTest
@testable import AlbumList
import ComposableArchitecture
import TCAExamEntities

final class AlbumListTests: XCTestCase {

    @MainActor
    func testFetchAlbum() async {
        let mockList: [Album] = [
            .init(id: UUID(), title: "test", artist: "test artist", musicList: [])
        ]

        let store = TestStore(
            initialState: AlbumListReducer.State(),
            reducer: { AlbumListReducer() },
            withDependencies: {
                $0.albumListClient = .init(
                    fetchAlbumList: { mockList }
                )
            }
        )

        await store.send(.fetchAblumList)
        await store.receive(.albumList(mockList)) {
            $0.albumList = mockList
        }
    }
}
