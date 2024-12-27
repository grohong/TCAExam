//
//  MusicPlayerView.swift
//  MusicPlayer
//
//  Created by Hong Seong Ho on 12/27/24.
//

import SwiftUI
import ComposableArchitecture
import TCAExamViews

public struct MusicPlayerView: View {

    let store: StoreOf<MusicPlayerReducer>

    public init(store: StoreOf<MusicPlayerReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            MusicPlayerMiniView(
                playAction: { viewStore.send(.play) },
                pauseAction: { viewStore.send(.pause) },
                tapAction: { viewStore.send(.showSheet) },
                playingState: viewStore.playingState,
                music: viewStore.music
            )
            .task { await viewStore.send(.onTask).finish() }
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
                    playingState: viewStore.playingState,
                    music: viewStore.music
                )
            }
        }
    }
}
