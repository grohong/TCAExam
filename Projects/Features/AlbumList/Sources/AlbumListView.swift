//
//  AlbumListView.swift
//  AlbumList
//
//  Created by Hong Seong Ho on 12/26/24.
//

import SwiftUI
import ComposableArchitecture
import TCAExamEntities
import TCAExamViews

public struct AlbumListView: View {

    let store: StoreOf<AlbumListReducer>

    public init(store: StoreOf<AlbumListReducer>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20
            ) {
                ForEach(store.albumList) { album in
                    Button {
                        store.send(.delegate(.didSelectAlbum(album: album)))
                    } label: {
                        AlbumCardView(album: album)
                    }
                }

            }
            .task {
                guard store.albumList.isEmpty == true else { return }
                store.send(.fetchAblumList)
            }
            .navigationTitle("앨범리스트")
        }
    }
}
