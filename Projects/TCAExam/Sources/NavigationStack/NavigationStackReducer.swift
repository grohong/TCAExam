//
//  NavigationStackReducer.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 12/27/24.
//

import Foundation
import ComposableArchitecture
import TCAExamEntities
import AlbumList
import Album

@Reducer
struct NavigationStackReducer {

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var albumList = AlbumListReducer.State()
    }

    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case albumList(AlbumListReducer.Action)
    }

    @Reducer
    struct Path {

        @ObservableState
        enum State: Equatable {
            case album(AlbumReducer.State)
        }

        enum Action: Equatable {
            case album(AlbumReducer.Action)
        }

        var body: some Reducer<State, Action> {
            Scope(state: \.album, action: \.album) {
                AlbumReducer()
            }
        }
    }

    var body: some Reducer<State, Action> {

        Scope(state: \.albumList, action: \.albumList) {
            AlbumListReducer()
        }

        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .albumList(.delegate(.didSelectAlbum(let album))):
                state.path.append(.album(AlbumReducer.State(album: album)))
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}
