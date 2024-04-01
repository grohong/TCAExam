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

    private let period: Double
    private let isPlaying: Bool
    private let music: Music?

    public init(
        playAction: @escaping () -> Void,
        pauseAction: @escaping () -> Void,
        tapAction: @escaping () -> Void,
        period: Double,
        isPlaying: Bool,
        music: Music?
    ) {
        self.playAction = playAction
        self.pauseAction = pauseAction
        self.tapAction = tapAction
        self.period = period
        self.isPlaying = isPlaying
        self.music = music
    }

    public var body: some View {
        VStack {
            ProgressView(value: period)
                .progressViewStyle(LinearProgressViewStyle())

            HStack {
                Button(action: {
                    if isPlaying {
                        pauseAction()
                    } else {
                        playAction()
                    }
                }) {
                    Image(systemName: isPlaying ? "pause.circle" : "play.circle")
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
            period: 0.4,
            isPlaying: true,
            music: nil
        )
        .previewLayout(.fixed(width: 375, height: 70))
    }
}
