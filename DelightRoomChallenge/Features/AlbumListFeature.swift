//
//  AlbumListFeature.swift
//  DelightRoomChallenge
//
//  Created by Hong Seong Ho on 3/31/24.
//

import SwiftUI
import ComposableArchitecture
import Entities
import Views

@Reducer
struct AlbumListFeature {

    @ObservableState
    struct State: Equatable {
        var albumList = [Album]()
    }

    enum Action: Equatable {
        case fetchAblumList
        case albumList([Album])
    }

    @Dependency(\.albumClient.fetchAlbumList) var fetchAlbumList

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchAblumList:
                return .run { send in
                    let ablumList = await fetchAlbumList()
                    await send(.albumList(ablumList))
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
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20
                ) {
                    ForEach(viewStore.albumList) { album in
                        NavigationLink(
                            state: AppFeature.Path.State.album(AlbumFeature.State(album: album))
                        ) {
                            AlbumCardView(album: album)
                        }
                    }

                }
                .task {
                    guard viewStore.albumList.isEmpty == true else { return }
                    viewStore.send(.fetchAblumList)
                }
            }
            .navigationTitle("앨범리스트")
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            AlbumListView(
                store: Store(initialState: AlbumListFeature.State())
                {  AlbumListFeature() }
            )
        }
    }
}
