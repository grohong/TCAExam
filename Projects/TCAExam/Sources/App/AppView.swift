//
//  AppView.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 12/27/24.
//

import SwiftUI
import ComposableArchitecture
import MusicPlayer

struct AppView: View {

    let store: StoreOf<AppReducer>

    var body: some View {
        VStack {
            NavigationStackView(
                store: store.scope(
                    state: \.navigationStack,
                    action: \.navigationStack
                )
            )

            if store.state.showPlayer {
                MusicPlayerView(
                    store: store.scope(
                        state: \.musicPlayer,
                        action: \.musicPlayer
                    )
                )
            }
        }
    }
}
