//
//  MusicPlayerManager.swift
//  MusicPlayerManager
//
//  Created by Hong Seong Ho on 12/27/24.
//

import AVFoundation
import MediaPlayer
import Combine
import TCAExamEntities

public actor MusicPlayerManager {

    public static let shared = MusicPlayerManager()

    private(set) var musicList = [Music]()
    private(set) var currentPlayIndex: Int = .zero

    private let player: PlayerProtocol
    private var currentTimeInSeconds: Float64 = .zero
    private var durationInSeconds: Float64 = .zero
    private var isPlaying = false

    private var currentMusicContinuation: AsyncStream<Music?>.Continuation?
    private var playingStateContinuation: AsyncStream<PlayingState>.Continuation?
    private var timeObserverToken: Any?
    private var cancellables = Set<AnyCancellable>()
    private var isSetActive = false

    init(player: PlayerProtocol = AVPlayer()) {
        self.player = player
        Task { await configureRemoteCommandCenter() }
    }

    private func setActive() {
        guard isSetActive == false else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            MPRemoteCommandCenter.shared().changePlaybackPositionCommand.isEnabled = true
            isSetActive = true
        } catch {
            isSetActive = false
        }
    }

    public func configureCurrentMusicContinuation(_ continuation: AsyncStream<Music?>.Continuation) async {
        self.currentMusicContinuation = continuation
    }

    public func configurePlayingStateContinuation(_ continuation: AsyncStream<PlayingState>.Continuation) async {
        self.playingStateContinuation = continuation
    }

    public func startPlay(musicList: [Music], index: Int) {
        self.musicList = musicList
        self.currentPlayIndex = index
        playCurrentIndexMusic()
    }

    public func play() {
        player.play()
        isPlaying = true
        playingStateContinuation?.yield(
            .init(
                isPlaying: true,
                currentTimeInSeconds: currentTimeInSeconds,
                durationInSeconds: durationInSeconds
            )
        )
        startTrackingPeriod()
    }

    public func pause() {
        player.pause()
        isPlaying = false
        playingStateContinuation?.yield(
            .init(
                isPlaying: false,
                currentTimeInSeconds: currentTimeInSeconds,
                durationInSeconds: durationInSeconds
            )
        )
        stopTrackingPeriod()
    }

    public func nextPlay() {
        let nextPlayIndex = currentPlayIndex + 1
        if nextPlayIndex <= musicList.count - 1 {
            currentPlayIndex = nextPlayIndex
        } else {
            currentPlayIndex = .zero
        }
        playCurrentIndexMusic()
    }

    public func prevPlay() {
        if currentPlayIndex <= .zero {
            currentPlayIndex = musicList.count - 1
        } else {
            currentPlayIndex = currentPlayIndex - 1
        }
        playCurrentIndexMusic()
    }

    public func seekToPosition(seconds: TimeInterval) {
        let cmTime = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: cmTime) { _ in }
    }

    private func playCurrentIndexMusic() {
        setActive()
        stopTrackingPeriod()
        let music = musicList[currentPlayIndex]
        let item = AVPlayerItem(url: music.assetURL)
        player.changeCurrentItem(with: item)
        currentMusicContinuation?.yield(musicList[currentPlayIndex])
        play()
        configureMPNowPlayingInfoCenter(item, music: music)
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
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            let currentTimeInSeconds = CMTimeGetSeconds(time)
            Task { await self.update(currentTimeInSeconds: currentTimeInSeconds) }
        }
    }

    private func stopTrackingPeriod() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    private func update(
        currentTimeInSeconds: Float64
    ) {
        guard let durationInSeconds = player.currentItem?.duration.seconds,
              durationInSeconds.isFinite == true else { return }
        self.currentTimeInSeconds = currentTimeInSeconds
        self.durationInSeconds = durationInSeconds
        playingStateContinuation?.yield(
            .init(
                isPlaying: isPlaying,
                currentTimeInSeconds: currentTimeInSeconds,
                durationInSeconds: durationInSeconds
            )
        )

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
    func addPeriodTimeObserver(forInterval interval: CMTime, queue: DispatchQueue, using: @Sendable @escaping (CMTime) -> Void) -> Any
    func removeTimeObserver(_ observer: Any)
    func seek(to time: CMTime, completionHandler: @Sendable @escaping (Bool) -> Void)
    var currentItem: AVPlayerItem? { get }
}

extension AVPlayer: PlayerProtocol {

    nonisolated func changeCurrentItem(with item: AVPlayerItem) {
        replaceCurrentItem(with: item)
    }

    nonisolated func addPeriodTimeObserver(forInterval interval: CMTime, queue: DispatchQueue, using: @Sendable @escaping (CMTime) -> Void) -> Any {
        addPeriodicTimeObserver(forInterval: interval, queue: queue, using: using)
    }
}
