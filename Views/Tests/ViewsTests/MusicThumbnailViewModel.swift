//
//  MusicThumbnailViewModel.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import XCTest
@testable import Views

final class MusicThumbnailViewModelTests: XCTestCase {

    func testThumbnailSuccess() async {
        let viewModel = MusicThumbnailViewModel()

        let expectedImage = UIImage(systemName: "photo")!
        let mockAsset = MockAsset()
        mockAsset.thumbnailImage = expectedImage
        await viewModel.loadThumbnail(by: mockAsset)

        XCTAssertNotNil(viewModel.image, "썸네일이 있을경우 image 반환")
    }

    func testLoadThumbnailFailure() async {
        let viewModel = MusicThumbnailViewModel()

        let mockAsset = MockAsset()
        mockAsset.thumbnailImage = nil
        await viewModel.loadThumbnail(by: mockAsset)

        XCTAssertNil(viewModel.image, "썸네일이 없을경우 nil 반환")
    }
}

import AVFoundation
import UIKit

class MockAsset: ThumbnailGeneratable {

    var thumbnailImage: UIImage?
    var thumbnail: UIImage? {
        get async { thumbnailImage }
    }
}
