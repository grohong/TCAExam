//
//  DelightRoomChallengeApp.swift
//  DelightRoomChallenge
//
//  Created by Hong Seong Ho on 3/29/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct DelightRoomChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            if DebugSettings.isRunningTests {
                Text("테스트 중입니다")
            } else {
                AppView(
                    store: Store(initialState: AppFeature.State()) {
                        AppFeature()
                            ._printChanges()
                    }
                )
            }
        }
    }
}

#if DEBUG
class DebugSettings {
    static var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
#endif
