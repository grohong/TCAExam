//
//  MusicPlayerManager+MediaPlayer.swift
//
//
//  Created by Hong Seong Ho on 4/2/24.
//

import MediaPlayer
import Entities

extension MusicPlayerManager {

    func configureMPNowPlayingInfoCenter(_ item: AVPlayerItem, music: Music) async {
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

    func configureRemoteCommandCenter() async {
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
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let self = self, let playbackPositionEvent = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            let newPosition = playbackPositionEvent.positionTime
            Task { await self.seekToPosition(seconds: newPosition) }
            return .success
        }
    }
}
