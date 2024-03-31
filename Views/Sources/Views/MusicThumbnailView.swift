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

extension AVAsset: ThumbnailGeneratable {

    public var thumbnail: UIImage? {
        get async {
            let metadata = try? await self.loadCommonMetadata()
            guard let metadata = try? await self.loadCommonMetadata(),
                  let artworkMetadata = metadata.first(where: { $0.commonKey == .commonKeyArtwork }),
                  let imageData = try? await artworkMetadata.load(.dataValue) else { return nil }
            return UIImage(data: imageData)
        }
    }

    private func loadCommonMetadata() async throws -> [AVMetadataItem] {
        try await withCheckedThrowingContinuation { continuation in
            self.loadMetadata(for: .id3Metadata) { metadata, error in
                if let metadata {
                    continuation.resume(returning: metadata)
                    return
                }

                if let error {
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }
}

