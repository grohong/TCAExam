//
//  MusicPlayerMiniViewPreviews.swift
//
//
//  Created by Hong Seong Ho on 4/2/24.
//

import SwiftUI
import TCAExamEntities
import TCAExamViews

struct MusicPlayerMiniViewPreviews: PreviewProvider {
    static var previews: some View {
        MusicPlayerMiniView(
            playAction: { },
            pauseAction: { },
            tapAction: { },
            playingState: .init(
                isPlaying: true, 
                currentTimeInSeconds: 3.0,
                durationInSeconds: 6.0
            ),
            music: nil
        )
        .previewLayout(.fixed(width: 375, height: 70))
    }
}
