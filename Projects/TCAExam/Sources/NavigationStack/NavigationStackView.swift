//
//  NavigationStackView.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 12/27/24.
//

import SwiftUI
import ComposableArchitecture
import Album
import AlbumList

struct NavigationStackView: View {

    let store: StoreOf<NavigationStackReducer>

    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            AlbumListView(
                store: store.scope(
                    state: \.albumList,
                    action: \.albumList
                )
            )
        } destination: { state in
            switch state {
            case .album:
                CaseLet(
                    \NavigationStackReducer.Path.State.album,
                     action: NavigationStackReducer.Path.Action.album,
                     then: AlbumView.init(store:)
                )
            }
        }
    }
}
