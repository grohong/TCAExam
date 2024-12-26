//
//  MusicThumbnailViewModel.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import XCTest
@testable import TCAExamViews

final class MusicThumbnailViewModelTests: XCTestCase {

    @MainActor
    func testThumbnailSuccess() async {
        let viewModel = MusicThumbnailViewModel()

        let mockAsset = MockAsset(thumbnailImage: UIImage(systemName: "photo")!)
        await viewModel.loadThumbnail(by: mockAsset)

        XCTAssertNotNil(viewModel.image, "썸네일이 있을경우 image 반환")
    }

    @MainActor
    func testLoadThumbnailFailure() async {
        let viewModel = MusicThumbnailViewModel()

        let mockAsset = MockAsset(thumbnailImage: nil)
        await viewModel.loadThumbnail(by: mockAsset)

        XCTAssertNil(viewModel.image, "썸네일이 없을경우 nil 반환")
    }
}

import AVFoundation
import UIKit

final class MockAsset: ThumbnailGeneratable {

    let thumbnailImage: UIImage?
    var thumbnail: UIImage? {
        get async { thumbnailImage }
    }

    init(thumbnailImage: UIImage?) {
        self.thumbnailImage = thumbnailImage
    }
}
