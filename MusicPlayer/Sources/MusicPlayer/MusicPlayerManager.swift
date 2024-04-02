//
//  MusicPlayerManager.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import AVFoundation
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

    private func playCurrentIndexMusic() async {
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: item
        )
    }

    @MainActor
    @objc private func playerItemDidReachEnd(notification: Notification) async {
        await nextPlay()
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

import MediaPlayer

extension MusicPlayerManager {

    private func configureMPNowPlayingInfoCenter(_ item: AVPlayerItem, music: Music) async {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = music.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = music.artist

        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = item.duration.seconds.isFinite
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Double.zero
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = Float.zero

        if let artworkImage = await item.asset.thumbnail {
            let artwork = MPMediaItemArtwork(boundsSize: artworkImage.size) { size in return artworkImage }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    private func configureRemoteCommandCenter() async {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            Task { await self.play() }
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            Task { await self.pause() }
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            Task { await self.nextPlay() }
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            Task { await self.prevPlay() }
            return .success
        }
    }
}
