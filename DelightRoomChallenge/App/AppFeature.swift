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
        var playAlbum: Album?
        var albumIndex: Int?
    }

    enum Action: Equatable {
        case navigationStack(NavigationStackFeature.Action)
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
                    state.playAlbum = album
                    state.albumIndex = index
                    return .none
                }
            default:
                return .none
            }
        }
    }
}

struct AppFeatureView: View {

    let store: StoreOf<AppFeature>

    var body: some View {
        NavigationStackView(
            store: self.store.scope(
                state: \.navigationStack,
                action: \.navigationStack
            )
        )
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
