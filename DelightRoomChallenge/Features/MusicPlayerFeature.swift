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
        @Presents var musicPlayerSheet: MusicPlayerSheetFeature.State?
        var music: Music?
        var isPlaying = true
        var period: Double = .zero
    }

    enum Action: Equatable {
        case musicPlayerSheet(PresentationAction<MusicPlayerSheetFeature.Action>)
        case showMusicPlayerSheet
        case play
        case pause
        case isPlayingChanged(Bool)
        case periodChanged(Double)
        case onTask
    }

    @Dependency(\.musicPlayerClient) var musicPlayerClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .musicPlayerSheet:
                return .none
            case .showMusicPlayerSheet:
                state.musicPlayerSheet = MusicPlayerSheetFeature.State(music: state.music)
                return .none
            case .play:
                return .run { send in
                    await musicPlayerClient.play()
                    await send(.isPlayingChanged(true))
                }
            case .pause:
                return .run { send in
                    await musicPlayerClient.pause()
                    await send(.isPlayingChanged(false))
                }
            case .isPlayingChanged(let isPlaying):
                state.isPlaying = isPlaying
                return .none
            case .periodChanged(let period):
                state.period = period
                return .none
            case .onTask:
                return .run { send in
                    await self.onTask(send: send)
                }
            }
        }
        .ifLet(\.$musicPlayerSheet, action: \.musicPlayerSheet) {
            MusicPlayerSheetFeature()
        }
    }

    private func onTask(send: Send<Action>) async {
        for await music in self.musicPlayerClient.period() {
            await send(.periodChanged(music))
        }
    }
}

struct MusicPlayerView: View {

    let store: StoreOf<MusicPlayerFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                ProgressView(value: viewStore.period)
                    .progressViewStyle(LinearProgressViewStyle())

                HStack {
                    Button(action: {
                        if viewStore.isPlaying {
                            viewStore.send(.pause)
                        } else {
                            viewStore.send(.play)
                        }
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
                    .contentShape(Rectangle())
                    .onTapGesture { viewStore.send(.showMusicPlayerSheet) }

                    Spacer()

                    MusicThumbnailView(viewStore.music?.asset)
                        .frame(width: 50, height: 50)
                        .id(viewStore.music?.id)
                        .onTapGesture { viewStore.send(.showMusicPlayerSheet) }
                }
                .frame(height: 60)
                .padding()
            }
            .task { await store.send(.onTask).finish() }
            .sheet(
                store: self.store.scope(
                    state: \.$musicPlayerSheet,
                    action: \.musicPlayerSheet
                )
            ) { store in
                NavigationStack {
                    MusicPlayerSheetView(store: store)
                }
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
