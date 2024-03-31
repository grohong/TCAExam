import XCTest
@testable import Entities

final class EntitiesTests: XCTestCase {

    func testResourceMock() throws {
        let mockAlbum = Album.mockAlbumList
        XCTAssertGreaterThan(mockAlbum.count, .zero, "모듈에 있는 MockResources가 잘 나오는지 확인")
    }
}
