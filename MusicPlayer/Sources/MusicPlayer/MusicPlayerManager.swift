//
//  MusicPlayerManager.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import AVFoundation
import Entities

public actor MusicPlayerManager {

    public static let shared = MusicPlayerManager()

    private(set) var musicList = [Music]()
    private(set) var currentPlayIndex: Int = .zero
    private let player :PlayerProtocol
    private var currentMusicContinuation: AsyncStream<Music?>.Continuation?
    private var periodContinuation: AsyncStream<Double>.Continuation?
    private var timeObserverToken: Any?

    init(player: PlayerProtocol = AVPlayer()) {
        self.player = player
    }

    public func configureCurrentMusicContinuation(_ continuation: AsyncStream<Music?>.Continuation) async {
        self.currentMusicContinuation = continuation
    }

    public func configurePeriodContinuation(_ continuation: AsyncStream<Double>.Continuation) async {
        self.periodContinuation = continuation
    }

    public func startPlay(musicList: [Music], index: Int) async {
        self.musicList = musicList
        self.currentPlayIndex = index
        await playCurrentIndexMusic()
    }

    public func play() async {
        player.play()
    }

    public func pause() async {
        player.pause()
    }

    public func nextPlay() async {
        let nextPlayIndex = currentPlayIndex + 1
        if nextPlayIndex <= musicList.count - 1 {
            currentPlayIndex = nextPlayIndex
        } else {
            currentPlayIndex = .zero
        }
        await playCurrentIndexMusic()
    }

    public func prevPlay() async {
        if currentPlayIndex <= .zero {
            currentPlayIndex = musicList.count - 1
        } else {
            currentPlayIndex = currentPlayIndex - 1
        }
        await playCurrentIndexMusic()
    }

    private func playCurrentIndexMusic() async {
        let item = AVPlayerItem(url: musicList[currentPlayIndex].assetURL)
        player.changeCurrentItem(with: item)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: item
        )
        startTrackingPeriod()
        currentMusicContinuation?.yield(musicList[currentPlayIndex])
        await play()
    }

    @MainActor
    @objc private func playerItemDidReachEnd(notification: Notification) async {
        await nextPlay()
    }

    private func startTrackingPeriod() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self, let duration = self.player.currentItem?.duration else { return }
            let durationInSeconds = CMTimeGetSeconds(duration)
            if durationInSeconds.isFinite {
                let currentTimeInSeconds = CMTimeGetSeconds(time)
                let progress = currentTimeInSeconds / durationInSeconds
                Task { await self.updatePeriod(progress) }
            }
        }
    }

    private func updatePeriod(_ progress: Double) {
        self.periodContinuation?.yield(progress)
    }
}

protocol PlayerProtocol {
    func play()
    func pause()
    func changeCurrentItem(with item: AVPlayerItem)
    func addPeriodTimeObserver(forInterval interval: CMTime, queue: DispatchQueue, using: @escaping (CMTime) -> Void)
    var currentItem: AVPlayerItem? { get }
}

extension AVPlayer: PlayerProtocol {

    func changeCurrentItem(with item: AVPlayerItem) {
        replaceCurrentItem(with: item)
    }

    func addPeriodTimeObserver(forInterval interval: CMTime, queue: DispatchQueue, using: @escaping (CMTime) -> Void) {
        addPeriodicTimeObserver(forInterval: interval, queue: queue, using: using)
    }
}
