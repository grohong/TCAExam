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
        var isSheetPresented: Bool = false
        var music: Music?
        var isPlaying = true
        var period: Double = .zero
    }

    enum Action: Equatable {
        case showSheet
        case hideSheet
        case play
        case pause
        case nextPlay
        case prevPlay
        case playStateChanged(PlayingState)
        case onTask
    }

    @Dependency(\.musicPlayerClient) var musicPlayerClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .showSheet:
                state.isSheetPresented = true
                return .none
            case .hideSheet:
                state.isSheetPresented = false
                return .none
            case .play:
                return .run { _ in await musicPlayerClient.play() }
            case .pause:
                return .run { _ in await musicPlayerClient.pause() }
            case .nextPlay:
                return .run { _ in await musicPlayerClient.nextPlay() }
            case .prevPlay:
                return .run { _ in await musicPlayerClient.prevPlay() }
            case .playStateChanged(let playingState):
                state.isPlaying = playingState.isPlaying
                state.period = playingState.period
                return .none
            case .onTask:
                return .run { send in
                    await self.onTask(send: send)
                }
            }
        }
    }

    private func onTask(send: Send<Action>) async {
        for await playingState in self.musicPlayerClient.playingState() {
            await send(.playStateChanged(playingState))
        }
    }
}

struct MusicPlayerView: View {

    let store: StoreOf<MusicPlayerFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            MusicPlayerMiniView(
                playAction: { viewStore.send(.play) },
                pauseAction: { viewStore.send(.pause) },
                tapAction: { viewStore.send(.showSheet) },
                period: viewStore.period,
                isPlaying: viewStore.isPlaying,
                music: viewStore.music
            )
            .task { await store.send(.onTask).finish() }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isSheetPresented,
                    send: { _ in .hideSheet }
                )
            ) {
                MusicPlayerSheetView(
                    action: { actionKind in
                        switch actionKind {
                        case .play:
                            viewStore.send(.play)
                        case .pause:
                            viewStore.send(.pause)
                        case .nextPlay:
                            viewStore.send(.nextPlay)
                        case .prevPlay:
                            viewStore.send(.prevPlay)
                        case .hide:
                            viewStore.send(.hideSheet)
                        }
                    },
                    period: viewStore.period,
                    isPlaying: viewStore.isPlaying,
                    music: viewStore.music
                )
            }
        }
    }
}

#Preview {
    MusicPlayerView(
        store: Store(
            initialState: MusicPlayerFeature.State(
                isSheetPresented: true,
                music: Album.mockAlbumList.first!.musicList.first
            )
        ) {
            MusicPlayerFeature()
        }
    )
}
