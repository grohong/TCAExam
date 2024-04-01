//
//  AlbumFeature.swift
//  DelightRoomChallenge
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import ComposableArchitecture
import Entities
import Views

@Reducer
struct AlbumFeature {

    @ObservableState
    struct State: Equatable {
        var album: Album
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
                AlbumHeaderView(album: viewStore.album)

                Divider()
                    .padding(.horizontal)

                PlayerControlView(
                    playAction: { },
                    shuffleAction: { }
                )

                MusicListView(musicList: viewStore.album.musicList)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            AlbumView(
                store: Store(initialState: AlbumFeature.State(album: Album.mockAlbumList.first!)) 
                { AlbumFeature() }
            )
        }
    }
}
