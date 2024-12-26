//
//  AlbumListExmapleApp.swift
//  AlbumList
//
//  Created by Hong Seong Ho on 12/26/24.
//

import SwiftUI
import ComposableArchitecture
import AlbumList

@main
struct AlbumListExmapleApp: App {

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                Text("테스트 중입니다")
            } else {
                NavigationView {
                    AlbumListView(
                        store: .init(
                            initialState: AlbumListReducer.State(),
                            reducer: { AlbumListReducer() }
                        )
                        .scope(
                            state: { state in
                                return state
                            },
                            action: { action in
                                if case let AlbumListReducer.Action.didSelectAlbum(album) = action {
                                    print("Selected album: \(album.title)")
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
