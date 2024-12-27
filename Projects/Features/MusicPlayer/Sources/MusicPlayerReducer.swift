//
//  MusicPlayerReducer.swift
//  MusicPlayer
//
//  Created by Hong Seong Ho on 12/27/24.
//

import ComposableArchitecture
import TCAExamEntities

@Reducer
public struct MusicPlayerReducer: Sendable {

    @ObservableState
    public struct State: Equatable {

        public var music: Music?
        var isSheetPresented: Bool = false
        var playingState = PlayingState(
            isPlaying: true,
            currentTimeInSeconds: .zero,
            durationInSeconds: .zero
        )

        public init(
            isSheetPresented: Bool = false,
            music: Music? = nil,
            playingState: PlayingState = PlayingState(
                isPlaying: true,
                currentTimeInSeconds: .zero,
                durationInSeconds: .zero
            )
        ) {
            self.isSheetPresented = isSheetPresented
            self.music = music
            self.playingState = playingState
        }
    }

    public enum Action: Equatable {
        case showSheet
        case hideSheet
        case play
        case pause
        case nextPlay
        case prevPlay
        case playStateChanged(PlayingState)
        case onTask
        case startAlbum([Music], Int)
        case currentMusicChanged(Music?)
    }

    @Dependency(\.musicPlayerClient) var musicPlayerClient

    public init() { }

    public var body: some Reducer<State, Action> {
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
                state.playingState = playingState
                return .none
            case let .currentMusicChanged(newMusic):
                state.music = newMusic
                return .none
            case .startAlbum(let musicList, let index):
                return .run { _ in
                    await musicPlayerClient.startAlbum((musicList, index))
                }
            case .onTask:
                return .run { send in
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask {
                            for await playingState in musicPlayerClient.playingState() {
                                await send(.playStateChanged(playingState))
                            }
                        }

                        group.addTask {
                            for await music in musicPlayerClient.currentMusic() {
                                await send(.currentMusicChanged(music))
                            }
                        }

                        await group.waitForAll()
                    }
                }
            }
        }
    }
}
