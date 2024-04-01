//
//  MusicPlayerSheetFeature.swift
//  DelightRoomChallenge
//
//  Created by Hong Seong Ho on 4/2/24.
//

import SwiftUI
import ComposableArchitecture
import Entities
import Views

@Reducer
struct MusicPlayerSheetFeature {

    @ObservableState
    struct State: Equatable {
        var music: Music?
    }

    enum Action: Equatable {

    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}

struct MusicPlayerSheetView: View {

    let store: StoreOf<MusicPlayerSheetFeature>

    @Dependency(\.musicPlayerClient.nextPlay) var nextPlay

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in

        }
    }
}

#Preview {
    MusicPlayerSheetView(
        store: Store(
            initialState: MusicPlayerSheetFeature.State(music: Album.mockAlbumList.first!.musicList.first)
        )
        { MusicPlayerSheetFeature() }
    )
}

