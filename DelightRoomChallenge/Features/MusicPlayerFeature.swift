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
        case isPlayingChanged(Bool)
        case periodChanged(Double)
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
                return .run { send in
                    await musicPlayerClient.play()
                    await send(.isPlayingChanged(true))
                }
            case .pause:
                return .run { send in
                    await musicPlayerClient.pause()
                    await send(.isPlayingChanged(false))
                }
            case .nextPlay:
                return .run { _ in
                    await musicPlayerClient.nextPlay()
                }
            case .prevPlay:
                return .run { _ in
                    await musicPlayerClient.prevPlay()
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
    }

    private func onTask(send: Send<Action>) async {
        for await music in self.musicPlayerClient.period() {
            await send(.periodChanged(music))
        }
    }
}

struct MusicPlayerView: View {

    let store: StoreOf<MusicPlayerFeature>
    @State private var progress = 0.0

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
                    .onTapGesture { viewStore.send(.showSheet) }

                    Spacer()

                    MusicThumbnailView(viewStore.music?.asset)
                        .frame(width: 50, height: 50)
                        .id(viewStore.music?.id)
                        .onTapGesture { viewStore.send(.showSheet) }
                }
                .frame(height: 60)
                .padding()
            }
            .task { await store.send(.onTask).finish() }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isSheetPresented,
                    send: { _ in .hideSheet }
                )
            ) {
                VStack {
                    HStack {
                        Button(action: {
                            viewStore.send(.hideSheet)
                        }) {
                            Image(systemName: "chevron.down")
                                .resizable()
                                .frame(width: 20, height: 10)
                        }
                        Spacer()
                        VStack {
                            Text(viewStore.music?.title ?? "곡 정보가 없습니다.")
                                .font(.title3)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            Text(viewStore.music?.artist ?? "아티스트 정보가 없습니다.")
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding()
                    .frame(height: 50)

                    Divider()

                    HStack {
                        Spacer()
                        MusicThumbnailView(viewStore.music?.asset)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .id(viewStore.music?.id)
                            .cornerRadius(8)
                        Spacer()
                    }
                    .padding(.horizontal)

                    HStack(spacing: 60) {
                        Button(action: {
                            viewStore.send(.prevPlay)
                        }) { Image(systemName: "backward.fill") }

                        Button(action: {
                            if viewStore.isPlaying {
                                viewStore.send(.pause)
                            } else {
                                viewStore.send(.play)
                            }
                        }) {
                            Image(systemName: viewStore.isPlaying ? "pause.fill" : "play.fill")
                        }

                        Button(action: {
                            viewStore.send(.nextPlay)
                        }) { Image(systemName: "forward.fill") }
                    }
                    .font(.largeTitle)
                    .padding()

                    Slider(value: $progress, in: 0...1, step: 0.01)
                        .accentColor(.blue)
                        .padding()

                    ProgressView(value: viewStore.period)
                        .progressViewStyle(LinearProgressViewStyle())
                }
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
