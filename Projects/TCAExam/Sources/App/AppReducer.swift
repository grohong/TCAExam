//
//  AppReducer.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 12/27/24.
//

import Foundation
import ComposableArchitecture
import TCAExamEntities

@Reducer
struct AppReducer {

    @ObservableState
    struct State: Equatable {
        var navigationStack = NavigationStackReducer.State()
    }

    enum Action: Equatable {
        case navigationStack(NavigationStackReducer.Action)
    }

    var body: some Reducer<State, Action> {

        Scope(state: \.navigationStack, action: \.navigationStack) {
            NavigationStackReducer()
        }

        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
