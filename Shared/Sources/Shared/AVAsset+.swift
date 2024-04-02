//
//  AVAsset+.swift
//
//
//  Created by Hong Seong Ho on 4/2/24.
//

import AVFoundation
import UIKit

extension AVAsset {

    public var thumbnail: UIImage? {
        get async {
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
