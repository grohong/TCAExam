//
//  AlbumFeature.swift
//  TCAExam
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
        case delegate(Delegate)
        enum Delegate: Equatable {
            case playAlbum(album: Album, startIndex: Int)
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            }
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
                    playAction: { viewStore.send(.delegate(.playAlbum(album: viewStore.album, startIndex: .zero))) },
                    shuffleAction: {
                        viewStore.send(.delegate(
                            .playAlbum(
                                album: viewStore.album,
                                startIndex: Int.random(in: 0..<viewStore.album.musicList.count)
                            )
                        ))
                    }
                )

                MusicListView(
                    musicList: viewStore.album.musicList,
                    tapAction: { index in
                        viewStore.send(.delegate(.playAlbum(album: viewStore.album, startIndex: index)))
                    }
                )
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AlbumView(
        store: Store(initialState: AlbumFeature.State(album: Album.mockAlbumList.first!)) 
        { AlbumFeature() }
    )
}
