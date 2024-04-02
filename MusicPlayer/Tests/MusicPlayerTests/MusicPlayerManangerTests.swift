import XCTest
@testable import MusicPlayer
import Entities

final class MusicPlayerManangerTests: XCTestCase {

    var musicPlayerManager: MusicPlayerManager!
    var mockPlayer: MockPlayer!

    let dummyMusicList = [
        Music(id: UUID(), title: "Song 1", artist: "Artist 1", assetURL: URL(string: "https://example.com/1.mp3")!),
        Music(id: UUID(), title: "Song 2", artist: "Artist 2", assetURL: URL(string: "https://example.com/2.mp3")!),
        Music(id: UUID(), title: "Song 2", artist: "Artist 2", assetURL: URL(string: "https://example.com/2.mp3")!),
        Music(id: UUID(), title: "Song 2", artist: "Artist 2", assetURL: URL(string: "https://example.com/2.mp3")!)
    ]

    override func setUp() {
        super.setUp()
        mockPlayer = MockPlayer()
        musicPlayerManager = MusicPlayerManager(player: mockPlayer)
    }

    override func tearDown() {
        musicPlayerManager = nil
        mockPlayer = nil
        super.tearDown()
    }

    func testPlay() async {
        await musicPlayerManager.play()
        XCTAssertTrue(mockPlayer.isPlaying, "play 함수 테스트 : isPlaying = true")
    }

    func testPause() async {
        await musicPlayerManager.play()
        XCTAssertTrue(mockPlayer.isPlaying, "play 함수 테스트 : isPlaying = true")

        await musicPlayerManager.pause()
        XCTAssertFalse(mockPlayer.isPlaying, "puase 함수 테스트 : isPlaying = false")
    }

    func testStartPlay() async {
        let playIndex: Int = 1
        await musicPlayerManager.startPlay(musicList: dummyMusicList, index: playIndex)

        XCTAssertTrue(mockPlayer.isPlaying, "startPlay시에 player가 재생되고 있어야 함")
        let currentMusicList = await musicPlayerManager.musicList
        XCTAssertEqual(currentMusicList, dummyMusicList, "musicPlayerManager의 musicList가 잘 설정 되어 있는지 확인")
        let currentIndex = await musicPlayerManager.currentPlayIndex
        XCTAssertEqual(currentIndex, playIndex, "musicPlayerManager의 currnetPlayIndex가 잘 설정 되어 있는지 확인")
    }

    func testNextPlay() async {
        let playIndex: Int = 1
        await musicPlayerManager.startPlay(musicList: dummyMusicList, index: playIndex)
        await musicPlayerManager.nextPlay()
        let currentIndex = await musicPlayerManager.currentPlayIndex
        XCTAssertEqual(currentIndex, playIndex + 1, "nextPlay시에 currnetPlayIndex가 +1 설정 되야함")
    }

    func testNextPlayInLast() async {
        let playIndex = dummyMusicList.count - 1

        await musicPlayerManager.startPlay(musicList: dummyMusicList, index: playIndex)
        await musicPlayerManager.nextPlay()
        let currentIndex = await musicPlayerManager.currentPlayIndex
        XCTAssertEqual(currentIndex, .zero, "musicList의 마지막 곡 재생중에 nextPlay 호출됐을때 currnetPlayIndex가 0으로 설정 되야함")
    }

    func testPrevPlay() async {
        let playIndex: Int = 1
        await musicPlayerManager.startPlay(musicList: dummyMusicList, index: playIndex)
        await musicPlayerManager.prevPlay()
        let currentIndex = await musicPlayerManager.currentPlayIndex
        XCTAssertEqual(currentIndex, playIndex - 1, "prevPlay시에 currnetPlayIndex가 -1 설정 되야함")
    }

    func testPrevPlayInFirst() async {
        let playIndex: Int = .zero
        await musicPlayerManager.startPlay(musicList: dummyMusicList, index: playIndex)
        await musicPlayerManager.prevPlay()
        let currentIndex = await musicPlayerManager.currentPlayIndex
        XCTAssertEqual(currentIndex, dummyMusicList.count - 1, "musicList의 첫번째 곡 재생중에 prevPlay 호출됐을때 currnetPlayIndex가 musicList의 마지막 곡으로 이동")
    }
}

import AVFoundation

class MockPlayer: PlayerProtocol {

    var isPlaying = false
    var currentItem: AVPlayerItem?

    func play() {
        isPlaying = true
    }

    func pause() {
        isPlaying = false
    }

    func changeCurrentItem(with item: AVPlayerItem) {
        currentItem = item
    }

    func addPeriodTimeObserver(forInterval interval: CMTime, queue: DispatchQueue, using block: @escaping (CMTime) -> Void) -> Any { return Any.self }
    func removeTimeObserver(_ observer: Any) { }
    func seek(to time: CMTime, completionHandler: @escaping (Bool) -> Void) { }
}
