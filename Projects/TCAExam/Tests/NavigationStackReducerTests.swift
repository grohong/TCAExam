//
//  NavigationStackReducerTests.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 12/28/24.
//

import XCTest
@testable import TCAExam
import ComposableArchitecture
import TCAExamEntities
import Album

final class NavigationStackReducerTests: XCTestCase {

    @MainActor
    func testAlbumNavigation() async {
        let store = TestStore(
            initialState: NavigationStackReducer.State(),
            reducer: { NavigationStackReducer() }
        )

        let mockAlbum = Album(id: UUID(), title: "테스트", artist: "테스트 아티스트", musicList: [])

        await store.send(.path(.push(id: 0, state: .album(AlbumReducer.State(album: mockAlbum))))) {
            $0.path[id: 0] = .album(AlbumReducer.State(album: mockAlbum))
        }
    }
}

