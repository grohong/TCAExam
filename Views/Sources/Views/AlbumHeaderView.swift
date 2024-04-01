//
//  AlbumHeaderView.swift
//  
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import Entities

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

struct AlbumHeaderViewPreviews: PreviewProvider {
    static var previews: some View {
        AlbumHeaderView(album: Album.mockAlbumList.first!)
            .previewLayout(.fixed(width: 375, height: 150))
    }
}
