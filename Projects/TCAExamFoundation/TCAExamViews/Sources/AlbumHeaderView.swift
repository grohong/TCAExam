//
//  AlbumHeaderView.swift
//  
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import TCAExamEntities

public struct AlbumHeaderView: View {

    private let album: Album

    public init(album: Album) {
        self.album = album
    }

    public var body: some View {
        HStack(alignment: .top) {
            MusicThumbnailView(album.musicList.first?.asset)
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(5)

            VStack(alignment: .leading) {
                Text(album.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(album.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding([.top, .horizontal])
    }
}
