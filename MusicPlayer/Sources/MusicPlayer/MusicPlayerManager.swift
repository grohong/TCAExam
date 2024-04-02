//
//  MusicPlayerManager.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import AVFoundation
import MediaPlayer
import Combine
import Entities
import Shared

public actor MusicPlayerManager {

    public static let shared = MusicPlayerManager()

    private(set) var musicList = [Music]()
    private(set) var currentPlayIndex: Int = .zero

    private let player: PlayerProtocol
    private var currentPeriod: Double = .zero
    private var isPlaying = false

    private var currentMusicContinuation: AsyncStream<Music?>.Continuation?
    private var playingStateContinuation: AsyncStream<PlayingState>.Continuation?
    private var timeObserverToken: Any?
    private var cancellables = Set<AnyCancellable>()

    init(player: PlayerProtocol = AVPlayer()) {
        self.player = player
        Task { await configureRemoteCommandCenter() }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    public func configureCurrentMusicContinuation(_ continuation: AsyncStream<Music?>.Continuation) async {
        self.currentMusicContinuation = continuation
    }

    public func configurePlayingStateContinuation(_ continuation: AsyncStream<PlayingState>.Continuation) async {
        self.playingStateContinuation = continuation
    }

    public func startPlay(musicList: [Music], index: Int) async {
        self.musicList = musicList
        self.currentPlayIndex = index
        await playCurrentIndexMusic()
    }

    public func play() async {
        player.play()
        isPlaying = true
        playingStateContinuation?.yield(.init(isPlaying: true, period: currentPeriod))
        startTrackingPeriod()
    }

    public func pause() async {
        player.pause()
        isPlaying = false
        playingStateContinuation?.yield(.init(isPlaying: false, period: currentPeriod))
        stopTrackingPeriod()
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

    public func seekToPosition(seconds: TimeInterval) {
        let cmTime = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: cmTime) { _ in }
    }

    private func playCurrentIndexMusic() async {
        stopTrackingPeriod()
        let music = musicList[currentPlayIndex]
        let item = AVPlayerItem(url: music.assetURL)
        player.changeCurrentItem(with: item)
        currentMusicContinuation?.yield(musicList[currentPlayIndex])
        await play()
        await configureMPNowPlayingInfoCenter(item, music: music)
        configurePlayerItemDidReachEndNotification(item)
    }

    private func configurePlayerItemDidReachEndNotification(_ item: AVPlayerItem) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default
            .publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
            .first()
            .sink() { [weak self] _ in
                guard let self else { return }
                Task { await self.nextPlay() }
            }
            .store(in: &cancellables)
    }

    private func startTrackingPeriod() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self, let playerItem = self.player.currentItem else { return }
            let currentTimeInSeconds = CMTimeGetSeconds(time)
            let durationInSeconds = CMTimeGetSeconds(playerItem.duration)
            if durationInSeconds.isFinite {
                Task {
                    await self.update(
                        currentTimeInSeconds: currentTimeInSeconds,
                        durationInSeconds: durationInSeconds
                    )
                }
            }
        }
    }

    private func stopTrackingPeriod() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    private func update(
        currentTimeInSeconds: Double,
        durationInSeconds: Double
    ) async {
        let period = currentTimeInSeconds / durationInSeconds
        self.currentPeriod = period
        playingStateContinuation?.yield(.init(isPlaying: isPlaying, period: period))

        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTimeInSeconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

protocol PlayerProtocol {
    func play()
    func pause()
    func changeCurrentItem(with item: AVPlayerItem)
    func addPeriodTimeObserver(forInterval interval: CMTime, queue: DispatchQueue, using: @escaping (CMTime) -> Void) -> Any
    func removeTimeObserver(_ observer: Any)
    func seek(to time: CMTime, completionHandler: @escaping (Bool) -> Void)
    var currentItem: AVPlayerItem? { get }
}

extension AVPlayer: PlayerProtocol {

    func changeCurrentItem(with item: AVPlayerItem) {
        replaceCurrentItem(with: item)
    }

    func addPeriodTimeObserver(forInterval interval: CMTime, queue: DispatchQueue, using: @escaping (CMTime) -> Void) -> Any {
        addPeriodicTimeObserver(forInterval: interval, queue: queue, using: using)
    }
}
