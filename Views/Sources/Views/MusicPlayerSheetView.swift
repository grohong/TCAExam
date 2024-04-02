//
//  MusicPlayerSheetView.swift
//  
//
//  Created by Hong Seong Ho on 4/2/24.
//

import SwiftUI
import Entities

public struct MusicPlayerSheetView: View {

    public enum ActionKind {
        case play
        case pause
        case nextPlay
        case prevPlay
        case hide
    }

    private var action: (ActionKind) -> Void
    private let playingState: PlayingState
    private let music: Music?

    public init(
        action: @escaping (ActionKind) -> Void,
        playingState: PlayingState,
        music: Music?
    ) {
        self.action = action
        self.playingState = playingState
        self.music = music
    }

    public var body: some View {
        VStack {
            HStack {
                Button(action: {
                    action(.hide)
                }) {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 20, height: 10)
                }
                Spacer()
                VStack {
                    Text(music?.title ?? "곡 정보가 없습니다.")
                        .font(.title3)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    Text(music?.artist ?? "아티스트 정보가 없습니다.")
                        .font(.subheadline)
                        .lineLimit(1)
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding()
            .frame(height: 50)

            Divider()

            HStack {
                Spacer()
                MusicThumbnailView(music?.asset)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .id(music?.id)
                    .cornerRadius(8)
                Spacer()
            }
            .padding(.horizontal)

            HStack(spacing: 60) {
                Button(action: {
                    action(.prevPlay)
                }) { Image(systemName: "backward.fill") }

                Button(action: {
                    if playingState.isPlaying {
                        action(.pause)
                    } else {
                        action(.play)
                    }
                }) {
                    Image(systemName: playingState.isPlaying ? "pause.fill" : "play.fill")
                }

                Button(action: {
                    action(.nextPlay)
                }) { Image(systemName: "forward.fill") }
            }
            .font(.largeTitle)
            .padding()

            SystemVolumeControlView()
                .frame(height: 80)
                .padding()

            HStack {
                Text(formatTime(time: playingState.currentTimeInSeconds))
                Spacer()
                Text("-\(formatTime(time:playingState.durationInSeconds - playingState.currentTimeInSeconds))")
            }
            .padding(.horizontal)

            ProgressView(value: playingState.period)
                .progressViewStyle(LinearProgressViewStyle())
        }
    }

    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct MusicPlayerSheetViewPreviews: PreviewProvider {
    static var previews: some View {
        MusicPlayerSheetView(
            action: { _ in },
            playingState: .init(
                isPlaying: true,
                currentTimeInSeconds: 0.4,
                durationInSeconds: 1.0
            ),
            music: nil
        )
        .previewLayout(.fixed(width: 375, height: 600))
    }
}
