//
//  AppFeature.swift
//  DelightRoomChallenge
//
//  Created by Hong Seong Ho on 4/2/24.
//

import SwiftUI
import ComposableArchitecture
import Entities

@Reducer
struct AppFeature {

    @ObservableState
    struct State: Equatable {
        var navigationStack = NavigationStackFeature.State()
        var musicPlayer: MusicPlayerFeature.State?
    }

    enum Action: Equatable {
        case navigationStack(NavigationStackFeature.Action)
        case musicPlayer(MusicPlayerFeature.Action)
    }

    @Dependency(\.musicPlayerClient) var musicPlayerClient

    var body: some Reducer<State, Action> {

        Scope(state: \.navigationStack, action: /Action.navigationStack) {
            NavigationStackFeature()
        }

        Reduce { state, action in
            switch action {
            case .navigationStack(.path(.element(_, action: .album(.delegate(let action))))):
                switch action {
                case .playAlbum(let album, let index):
                    state.musicPlayer = MusicPlayerFeature.State(music: album.musicList[index])
                    return .none
                }
            default:
                return .none
            }
        }
        .ifLet(\.musicPlayer, action: \.musicPlayer) {
            MusicPlayerFeature()
        }
    }
}

struct AppFeatureView: View {

    let store: StoreOf<AppFeature>

    var body: some View {
        VStack {
            NavigationStackView(
                store: self.store.scope(
                    state: \.navigationStack,
                    action: \.navigationStack
                )
            )

            if let musicPlayerStore = store.scope(state: \.musicPlayer, action: \.musicPlayer) {
                MusicPlayerView(store: musicPlayerStore)
            }
        }
    }
}

#Preview {
    AppFeatureView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
                ._printChanges()
        }
    )
}
