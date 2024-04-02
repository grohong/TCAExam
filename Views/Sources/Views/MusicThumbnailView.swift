//
//  MusicThumbnailView.swift
//  
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI

public protocol ThumbnailGeneratable {
    var thumbnail: UIImage? { get async }
}

public class MusicThumbnailViewModel: ObservableObject {

    @Published var image: Image? = nil

    func loadThumbnail(by thumbnailGeneratable: ThumbnailGeneratable?) async {
        if let uiImage = await thumbnailGeneratable?.thumbnail {
            await MainActor.run { self.image = Image(uiImage: uiImage) }
        }
    }
}

public struct MusicThumbnailView: View {

    @StateObject private var musicThumbnailViewModel = MusicThumbnailViewModel()

    private let thumbnailGeneratable: ThumbnailGeneratable?

    public init(_ thumbnailGeneratable: ThumbnailGeneratable?) {
        self.thumbnailGeneratable = thumbnailGeneratable
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack {
                if let image = musicThumbnailViewModel.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.gray
                        .frame(width: geometry.size.width, height: geometry.size.width)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .task { await musicThumbnailViewModel.loadThumbnail(by: thumbnailGeneratable) }
    }
}

import AVFoundation
import Shared

extension AVAsset: ThumbnailGeneratable { }

import Entities

struct MusicThumbnailViewPreviews: PreviewProvider {
    static var previews: some View {
        MusicThumbnailView(Album.mockAlbumList.first!.musicList.first!.asset)
            .previewLayout(.fixed(width: 150, height: 150))
    }
}
