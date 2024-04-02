//
//  AVAssetTests.swift
//
//
//  Created by Hong Seong Ho on 4/2/24.
//

import XCTest
@testable import Shared
import AVFoundation

class AVAssetThumbnailTests: XCTestCase {

    func testThumbnailSuccess() async {
        let mockAsset = MockAVAsset()
        let imageData = UIImage(systemName: "backward.fill")!.pngData()!
        let metadataItem = AVMutableMetadataItem()
        metadataItem.key = AVMetadataKey.commonKeyArtwork as (NSCopying & NSObjectProtocol)?
        metadataItem.keySpace = AVMetadataKeySpace.common
        metadataItem.value = imageData as any NSCopying & NSObjectProtocol
        metadataItem.dataType = kCMMetadataBaseDataType_RawData as String
        mockAsset.testMetadata = [metadataItem]

        let thumbnail = await mockAsset.thumbnail
        XCTAssertNotNil(thumbnail, "Thumbnail should not be nil for assets with artwork.")
    }

    func testThumbnailFailure() async {
        let mockAsset = MockAVAsset()
        mockAsset.testMetadata = nil

        let thumbnail = await mockAsset.thumbnail
        XCTAssertNil(thumbnail, "commonKeyArtworkr가 저의 되지 않은 상태 테스트")
    }
}

class MockAVAsset: AVAsset {

    var testMetadata: [AVMetadataItem]?

    override func loadMetadata(for format: AVMetadataFormat, completionHandler handler: @escaping ([AVMetadataItem]?, Error?) -> Void) {
        if let testMetadata = testMetadata {
            handler(testMetadata, nil)
        } else {
            handler(nil, NSError(domain: "TestError", code: -1, userInfo: nil))
        }
    }
}
