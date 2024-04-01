//
//  AlbumFeature.swift
//  DelightRoomChallenge
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AlbumFeature {

    @ObservableState
    struct State: Equatable {

    }

    enum Action: Equatable {

    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}

struct AlbumView: View {

    let store: StoreOf<AlbumFeature>


    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("AlbumDetail")
            }
            .padding()
        }
    }
}
