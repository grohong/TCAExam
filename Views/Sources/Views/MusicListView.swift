//
//  MusicListView.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import Entities

public struct MusicListView: View {

    private let musicList: [Music]
    private var tapAction: (_ index: Int) -> Void

    public init(
        musicList: [Music],
        tapAction: @escaping (_ index: Int) -> Void
    ) {
        self.musicList = musicList
        self.tapAction = tapAction
    }

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(
                    Array(musicList.enumerated()),
                    id: \.element.id
                ) { index, music in
                    MusicView(
                        index: index,
                        music: music,
                        tapAction: tapAction
                    )
                }
                .padding([.horizontal, .vertical])
            }
        }
    }
}

struct MusicView: View {

    private let index: Int
    private let music: Music
    private var tapAction: (_ index: Int) -> Void

    init(
        index: Int,
        music: Music,
        tapAction: @escaping (_ index: Int) -> Void
    ) {
        self.index = index
        self.music = music
        self.tapAction = tapAction
    }

    var body: some View {
        HStack {
            Text("\(index + 1)")
                .foregroundColor(.secondary)

            VStack(alignment: .leading) {
                Text(music.title)
                    .fontWeight(.semibold)

                Text(music.artist)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture { tapAction(index) }
    }
}

struct MusicListViewPreviews: PreviewProvider {
    static var previews: some View {
        MusicListView(
            musicList: Album.mockAlbumList.first!.musicList,
            tapAction: { _ in }
        )
            .previewLayout(.fixed(width: 375, height: 300))
    }
}
