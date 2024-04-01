//
//  AlbumCardView.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import Entities

public struct AlbumCardView: View {

    private let album: Album

    public init(album: Album) {
        self.album = album
    }

    public var body: some View {
        VStack {
            MusicThumbnailView(album.musicList.first?.asset)
            Text(album.title)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Text(album.artist)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
}

struct AlbumCardViewPreviews: PreviewProvider {
    static var previews: some View {
        AlbumCardView(album: Album.mockAlbumList.first!)
            .previewLayout(.fixed(width: 150, height: 150))
    }
}
