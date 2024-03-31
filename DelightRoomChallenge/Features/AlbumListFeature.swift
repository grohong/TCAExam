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
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20
                ) {
                    ForEach(viewStore.albumList) { album in
                        VStack {
                            MusicThumbnailView(album.musicList.first?.asset)
                            Text(album.title) // 제목
                                .fontWeight(.semibold)
                            Text(album.artist) // 작가 이름
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }

                }
                .task { viewStore.send(.fetchAblumList) }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            AlbumListView(
                store: Store(initialState: AlbumListFeature.State())
                {
                    AlbumListFeature()
                }
            )
        }
    }
}
