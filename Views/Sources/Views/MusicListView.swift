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

    public init(musicList: [Music]) {
        self.musicList = musicList
    }

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(
                    Array(musicList.enumerated()),
                    id: \.element.id
                ) { index, music in
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
                }
            }
            .padding([.horizontal, .vertical])
        }
    }
}

struct MusicListViewPreviews: PreviewProvider {
    static var previews: some View {
        MusicListView(musicList: Album.mockAlbumList.first!.musicList)
            .previewLayout(.fixed(width: 375, height: 300))
    }
}
