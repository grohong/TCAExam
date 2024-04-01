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
        case currentMusicChanged(Music?)
        case onTask
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
                    return .run { _ in
                        await musicPlayerClient.startAlbum((album.musicList, index))
                    }
                }
            case .currentMusicChanged(let music):
                if state.musicPlayer != nil {
                    if let music {
                        state.musicPlayer?.music = music
                    } else {
                        state.musicPlayer = nil
                    }
                } else {
                    if let music {
                        state.musicPlayer = MusicPlayerFeature.State(music: music)
                    }
                }
                return .none
            case .onTask:
                return .run { send in
                    await self.onTask(send: send)
                }
            default:
                return .none
            }
        }
        .ifLet(\.musicPlayer, action: \.musicPlayer) {
            MusicPlayerFeature()
        }
    }

    private func onTask(send: Send<Action>) async {
        for await music in self.musicPlayerClient.currentMusic() {
            await send(.currentMusicChanged(music))
        }
    }
}

struct AppFeatureView: View {

    let store: StoreOf<AppFeature>

    var body: some View {
        VStack {
            NavigationStackView(
                store: store.scope(
                    state: \.navigationStack,
                    action: \.navigationStack
                )
            )

            if let musicPlayerStore = store.scope(state: \.musicPlayer, action: \.musicPlayer) {
                MusicPlayerView(store: musicPlayerStore)
            }
        }
        .task { await store.send(.onTask).finish() }
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
