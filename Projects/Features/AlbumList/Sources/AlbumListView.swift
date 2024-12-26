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
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20
                ) {
                    ForEach(viewStore.albumList) { album in
                        Button {
                            viewStore.send(.didSelectAlbum(album))
                        } label: {
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
