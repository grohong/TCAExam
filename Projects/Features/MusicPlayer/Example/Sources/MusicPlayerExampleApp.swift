//
//  MusicPlayerExampleApp.swift
//  MusicPlayer
//
//  Created by Hong Seong Ho on 12/27/24.
//

import SwiftUI
import ComposableArchitecture
import MusicPlayer
import TCAExamEntities
import SharedMock

@main
struct MusicPlayerExampleApp: App {

    let store = StoreOf<MusicPlayerReducer>(
        initialState: MusicPlayerReducer.State(),
        reducer: { MusicPlayerReducer() }
    )

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                Text("테스트 중입니다")
            } else {
                NavigationView {
                    VStack {
                        Button("랜덤 음악 재생") {
                            let musicList = randomMusicFromMockAlbum()
                            store.send(.startAlbum(musicList, 0))
                        }
                        .padding()

                        MusicPlayerView(store: store)
                    }
                }
            }
        }
    }

    private func randomMusicFromMockAlbum() -> [Music] {
        guard let randomMusicList = Album.mockAlbumList.randomElement()?.musicList else { return [] }
        return randomMusicList
    }
}
