//
//  AlbumView.swift
//  AlbumList
//
//  Created by Hong Seong Ho on 12/26/24.
//

import SwiftUI
import ComposableArchitecture
import TCAExamEntities
import TCAExamViews

public struct AlbumView: View {

    let store: StoreOf<AlbumReducer>

    public init(store: StoreOf<AlbumReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            AlbumHeaderView(album: store.album)

            Divider()
                .padding(.horizontal)

            PlayerControlView(
                playAction: { store.send(.delegate(.playAlbum(album: store.album, startIndex: .zero))) },
                shuffleAction: {
                    store.send(.delegate(
                        .playAlbum(
                            album: store.album,
                            startIndex: Int.random(in: 0..<store.album.musicList.count)
                        )
                    ))
                }
            )

            MusicListView(
                musicList: store.album.musicList,
                tapAction: { index in
                    store.send(.delegate(.playAlbum(album: store.album, startIndex: index)))
                }
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
