//
//  MusicPlayerExampleApp.swift
//  MusicPlayer
//
//  Created by Hong Seong Ho on 12/27/24.
//

import SwiftUI
import ComposableArchitecture
import MusicPlayer

@main
struct MusicPlayerExampleApp: App {
    
    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                Text("테스트 중입니다")
            } else {
                NavigationView {
                    MusicPlayerView(
                        store: .init(
                            initialState: MusicPlayerReducer.State(),
                            reducer: { MusicPlayerReducer() }
                        )
                        .scope(
                            state: \.self,
                            action: { action in
                                return action
                            }
                        )
                    )
                }
            }
        }
    }
}
