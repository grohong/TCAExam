//
//  NavigationStackFeature.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 3/31/24.
//

import SwiftUI
import ComposableArchitecture
import Entities

@Reducer
struct NavigationStackFeature {

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var albumList = AlbumListFeature.State()
    }

    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case albumList(AlbumListFeature.Action)
    }

    @Reducer
    struct Path {

        @ObservableState
        enum State: Equatable {
            case album(AlbumFeature.State)
        }

        enum Action: Equatable {
            case album(AlbumFeature.Action)
        }

        var body: some Reducer<State, Action> {
            Scope(state: /State.album, action: /Action.album) {
                AlbumFeature()
            }
        }
    }

    var body: some Reducer<State, Action> {

        Scope(state: \.albumList, action: /Action.albumList) {
            AlbumListFeature()
        }

        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .albumList:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

struct NavigationStackView: View {

    let store: StoreOf<NavigationStackFeature>

    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            AlbumListView(
                store: store.scope(
                    state: \.albumList,
                    action: \.albumList
                )
            )
        } destination: { state in
            switch state {
            case .album:
                CaseLet(
                    /NavigationStackFeature.Path.State.album,
                     action: NavigationStackFeature.Path.Action.album,
                     then: AlbumView.init(store:)
                )
            }
        }
    }
}

#Preview {
    NavigationStackView(
        store: Store(initialState: NavigationStackFeature.State()) {
            NavigationStackFeature()
                ._printChanges()
        }
    )
}

#Preview("Album navigation test") {
    NavigationStackView(
        store: Store(
            initialState: NavigationStackFeature.State(
                path: StackState([
                    .album(AlbumFeature.State(album: Album.mockAlbumList.first!))
                ])
            )
        ) 
        {
            NavigationStackFeature()
                ._printChanges()
        }
    )
}
