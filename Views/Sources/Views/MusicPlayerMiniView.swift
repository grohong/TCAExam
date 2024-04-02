//
//  MusicPlayerMiniView.swift
//
//
//  Created by Hong Seong Ho on 4/2/24.
//

import SwiftUI
import Entities

public struct MusicPlayerMiniView: View {

    private var playAction: () -> Void
    private var pauseAction: () -> Void
    private var tapAction: () -> Void

    private let playingState: PlayingState
    private let music: Music?

    public init(
        playAction: @escaping () -> Void,
        pauseAction: @escaping () -> Void,
        tapAction: @escaping () -> Void,
        playingState: PlayingState,
        music: Music?
    ) {
        self.playAction = playAction
        self.pauseAction = pauseAction
        self.tapAction = tapAction
        self.playingState = playingState
        self.music = music
    }

    public var body: some View {
        VStack {
            ProgressView(value: playingState.period)
                .progressViewStyle(LinearProgressViewStyle())

            HStack {
                Button(action: {
                    if playingState.isPlaying {
                        pauseAction()
                    } else {
                        playAction()
                    }
                }) {
                    Image(systemName: playingState.isPlaying ? "pause.circle" : "play.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }

                Spacer()

                VStack(alignment: .leading) {
                    Text(music?.title ?? "곡 정보가 없습니다.")
                        .font(.headline)
                    Text(music?.artist ?? "아티스트 정보가 없습니다.")
                        .font(.subheadline)
                }
                .contentShape(Rectangle())
                .onTapGesture { tapAction() }

                Spacer()

                MusicThumbnailView(music?.asset)
                    .frame(width: 50, height: 50)
                    .id(music?.id)
                    .onTapGesture { tapAction() }
            }
            .frame(height: 60)
            .padding()
        }
    }
}

struct MusicPlayerMiniViewPreviews: PreviewProvider {
    static var previews: some View {
        MusicPlayerMiniView(
            playAction: { },
            pauseAction: { },
            tapAction: { },
            playingState: .init(
                isPlaying: true, 
                currentTimeInSeconds: .zero,
                durationInSeconds: .zero
            ),
            music: nil
        )
        .previewLayout(.fixed(width: 375, height: 70))
    }
}
