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
    func testPlayAlbum() async {
        let mockAlbum = Album.mockAlbumList.first!
        let startIndex: Int = .zero
        let store = TestStore(
            initialState: AppFeature.State(
                navigationStack: NavigationStackFeature.State(
                    path: StackState([.album(AlbumFeature.State(album: mockAlbum))])
                )
            )
        ) {
            AppFeature()
        }

        await store.send(.navigationStack(.path(.element(id: 0, action: .album(.delegate(.playAlbum(album: mockAlbum, startIndex: startIndex))))))) { state in
            state.musicPlayer = MusicPlayerFeature.State(music: mockAlbum.musicList[startIndex])
        }
    }
}
