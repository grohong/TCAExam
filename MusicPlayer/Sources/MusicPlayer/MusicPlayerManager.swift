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
    private let player: PlayerProtocol
    private var currentMusicContinuation: AsyncStream<Music?>.Continuation?
    private var periodContinuation: AsyncStream<Double>.Continuation?
    private var timeObserverToken: Any?

    init(player: PlayerProtocol = AVPlayer()) {
        self.player = player
        configureRemoteCommandCenter()
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
        let music = musicList[currentPlayIndex]
        let item = AVPlayerItem(url: music.assetURL)
        player.changeCurrentItem(with: item)
        currentMusicContinuation?.yield(musicList[currentPlayIndex])
        await play()
        configurePlayerItemDidReachEndNotification(item)
        startTrackingPeriod()
        await configureMPNowPlayingInfoCenter(item, music: music)
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

            var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTimeInSeconds
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

            if durationInSeconds.isFinite {
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
    var rate: Float { get }
}

extension AVPlayer: PlayerProtocol {

    func changeCurrentItem(with item: AVPlayerItem) {
        replaceCurrentItem(with: item)
    }

    func addPeriodTimeObserver(forInterval interval: CMTime, queue: DispatchQueue, using: @escaping (CMTime) -> Void) {
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
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = item.currentTime().seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

        if let artworkImage = await item.asset.thumbnail {
            let artwork = MPMediaItemArtwork(boundsSize: artworkImage.size) { size in return artworkImage }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    private func configureRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [weak self] event in
            Task { await self?.play() }
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] event in
            Task { await self?.pause() }
            return .success
        }
    }
}

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
