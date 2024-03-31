//
//  AlbumListFeature.swift
//  DelightRoomChallenge
//
//  Created by Hong Seong Ho on 3/31/24.
//

import SwiftUI
import ComposableArchitecture
import Entities

@Reducer
struct AlbumListFeature {

    @ObservableState
    struct State: Equatable {
        var albumList = IdentifiedArrayOf<Album>()
    }

    enum Action: Equatable {
        case fetchAblumList
        case albumList(IdentifiedArrayOf<Album>)
    }

    @Dependency(\.albumClient.fetchAlbumList) var fetchAlbumList

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchAblumList:
                return .run { send in
                    let ablumList = await fetchAlbumList()
                    await send(.albumList(IdentifiedArrayOf(uniqueElements: ablumList)))
                }
            case .albumList(let albumList):
                state.albumList = albumList
                return .none
            }
        }
    }
}

struct AlbumListView: View {

    let store: StoreOf<AlbumListFeature>


    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("AlbumListCount")
            }
            .padding()
            .task { viewStore.send(.fetchAblumList) }
        }
    }
}
