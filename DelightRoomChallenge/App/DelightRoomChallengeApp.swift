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
            AppView(
                store: Store(initialState: AppFeature.State()) {
                    AppFeature()
                        ._printChanges()
                }
            )
        }
    }
}
