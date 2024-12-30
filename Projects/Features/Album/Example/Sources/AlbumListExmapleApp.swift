//
//  AlbumListExmapleApp.swift
//  AlbumList
//
//  Created by Hong Seong Ho on 12/26/24.
//

import SwiftUI
import ComposableArchitecture
import TCAExamEntities
import SharedMock
import Album

@main
struct AlbumListExmapleApp: App {

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                Text("테스트 중입니다")
            } else {
                NavigationView {
                    AlbumView(
                        store: .init(
                            initialState: AlbumReducer.State(album: Album.mockAlbumList.first!),
                            reducer: { AlbumReducer() }
                        )
                        .scope(
                            state: \.self,
                            action: { action in
                                if case let AlbumReducer.Action.delegate(.playAlbum(album, startIndex)) = action {
                                    print("Playing album: \(album.title), startIndex: \(startIndex)")
                                }
                                return action
                            }
                        )
                    )
                }
            }
        }
    }
}
