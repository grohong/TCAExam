//
//  AlbumListReducer.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 3/31/24.
//

import ComposableArchitecture
import TCAExamEntities

@Reducer
public struct AlbumListReducer: Sendable {

    @ObservableState
    public struct State: Equatable {
        var albumList = [Album]()

        public init(albumList: [Album] = [Album]()) {
            self.albumList = albumList
        }
    }

    public enum Action: Equatable {
        case fetchAblumList
        case albumList([Album])
        case delegate(Delegate)
        public enum Delegate: Equatable {
            case didSelectAlbum(album: Album)
        }
    }

    @Dependency(\.albumListClient.fetchAlbumList) var fetchAlbumList

    public init() { }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchAblumList:
                return .run { send in
                    let ablumList = await fetchAlbumList()
                    await send(.albumList(ablumList))
                }
            case .albumList(let albumList):
                state.albumList = albumList
                return .none
            default:
                return .none
            }
        }
    }
}
