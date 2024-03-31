//
//  AppFeature.swift
//  DelightRoomChallenge
//
//  Created by Hong Seong Ho on 3/31/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AppFeature {

    @ObservableState
    struct State: Equatable {
        var albumList = AlbumListFeature.State()
    }

    enum Action: Equatable {
        case albumList(AlbumListFeature.Action)
    }

    var body: some Reducer<State, Action> {

        Scope(state: \.albumList, action: /Action.albumList) {
            AlbumListFeature()
        }

        Reduce { state, action in
            switch action {
            case .albumList:
                return .none
            }
        }
    }
}

struct AppView: View {

    let store: StoreOf<AppFeature>

    var body: some View {
        AlbumListView(
            store: store.scope(
                state: \.albumList,
                action: \.albumList
            )
        )
    }
}
