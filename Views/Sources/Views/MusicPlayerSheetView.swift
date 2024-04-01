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
    private let period: Double
    private let isPlaying: Bool
    private let music: Music?
    @Binding private var soundVolume: Double

    public init(
        action: @escaping (ActionKind) -> Void,
        period: Double,
        isPlaying: Bool,
        music: Music?,
        soundVolume: Binding<Double>
    ) {
        self.action = action
        self.period = period
        self.isPlaying = isPlaying
        self.music = music
        _soundVolume = soundVolume
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
                    if isPlaying {
                        action(.pause)
                    } else {
                        action(.play)
                    }
                }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                }

                Button(action: {
                    action(.nextPlay)
                }) { Image(systemName: "forward.fill") }
            }
            .font(.largeTitle)
            .padding()

            Slider(value: $soundVolume, in: 0...1, step: 0.01)
                .accentColor(.blue)
                .padding()

            ProgressView(value: period)
                .progressViewStyle(LinearProgressViewStyle())
        }
    }
}

struct MusicPlayerSheetViewPreviews: PreviewProvider {
    static var previews: some View {
        MusicPlayerSheetView(
            action: { _ in },
            period: 0.4,
            isPlaying: true,
            music: nil,
            soundVolume: .constant(0.5)
        )
        .previewLayout(.fixed(width: 375, height: 600))
    }
}
