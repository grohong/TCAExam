//
//  AlbumReducer.swift
//  TCAExam
//
//  Created by Hong Seong Ho on 3/31/24.
//

import ComposableArchitecture
import TCAExamEntities

@Reducer
public struct AlbumReducer: Sendable {

    @ObservableState
    public struct State: Equatable {
        var album: Album

        public init(album: Album) {
            self.album = album
        }
    }

    public init() { }

    public enum Action: Equatable {
        case delegate(Delegate)
        public enum Delegate: Equatable {
            case playAlbum(album: Album, startIndex: Int)
        }
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            }
        }
    }
}
