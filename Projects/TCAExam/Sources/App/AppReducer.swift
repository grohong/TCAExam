//
//  AppReducer.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 12/27/24.
//

import Foundation
import ComposableArchitecture
import MusicPlayer
import TCAExamEntities

@Reducer
struct AppReducer {

    @ObservableState
    struct State: Equatable {
        var navigationStack = NavigationStackReducer.State()
        var musicPlayer = MusicPlayerReducer.State()
        var showPlayer = false
    }

    enum Action: Equatable {
        case navigationStack(NavigationStackReducer.Action)
        case musicPlayer(MusicPlayerReducer.Action)
    }

    var body: some Reducer<State, Action> {

        Scope(state: \.navigationStack, action: \.navigationStack) {
            NavigationStackReducer()
        }

        Scope(state: \.musicPlayer, action: \.musicPlayer) {
            MusicPlayerReducer()
        }

        Reduce { state, action in
            switch action {
            case .navigationStack(.path(.element(_, action: .album(.delegate(let action))))):
                switch action {
                case .playAlbum(let album, let index):
                    if state.showPlayer == false {
                        state.showPlayer.toggle()
                    }
                    return .send(.musicPlayer(.startAlbum(album.musicList, index)))
                }
            default:
                return .none
            }
        }
    }
}
