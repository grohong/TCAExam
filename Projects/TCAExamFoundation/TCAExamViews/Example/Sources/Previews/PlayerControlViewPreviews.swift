//
//  PlayerControlViewPreviews.swift
//
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI
import TCAExamViews

struct PlayerControlViewPreviews: PreviewProvider {
    static var previews: some View {
        PlayerControlView(
            playAction: { },
            shuffleAction: { }
        )
            .previewLayout(.fixed(width: 375, height: 80))
    }
}
