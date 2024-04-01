//
//  MusicPlayerFeature.swift
//  DelightRoomChallenge
//
//  Created by Hong Seong Ho on 4/2/24.
//

import SwiftUI
import ComposableArchitecture
import Entities
import Views

@Reducer
struct MusicPlayerFeature {

    @ObservableState
    struct State: Equatable {
        var music: Music?
        var isPlaying = true
    }

    enum Action: Equatable {

    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}

struct MusicPlayerView: View {

    let store: StoreOf<MusicPlayerFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                ProgressView(value: 0.8)
                    .progressViewStyle(LinearProgressViewStyle())

                HStack {

                    Button(action: {

                    }) {
                        Image(systemName: viewStore.isPlaying ? "pause.circle" : "play.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        Text(viewStore.music?.title ?? "곡 정보가 없습니다.")
                            .font(.headline)
                        Text(viewStore.music?.artist ?? "아티스트 정보가 없습니다.")
                            .font(.subheadline)
                    }

                    Spacer()

                    MusicThumbnailView(viewStore.music?.asset)
                        .frame(width: 50, height: 50)


                }
                .frame(height: 60)
                .padding()
            }
        }
    }
}

#Preview {
    MusicPlayerView(
        store: Store(
            initialState: MusicPlayerFeature.State(music: Album.mockAlbumList.first!.musicList.first)
        )
        { MusicPlayerFeature() }
    )
}
