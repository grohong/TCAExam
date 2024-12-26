//
//  MusicPlayerSheetViewPreviews.swift
//  
//
//  Created by Hong Seong Ho on 4/2/24.
//

import SwiftUI
import TCAExamEntities
import TCAExamViews

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
