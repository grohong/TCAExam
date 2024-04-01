//
//  PlayerControlView.swift
//  
//
//  Created by Hong Seong Ho on 4/1/24.
//

import SwiftUI

public struct PlayerControlView: View {

    private let playAction: () -> Void
    private let shuffleAction: () -> Void

    public init(
        playAction: @escaping () -> Void,
        shuffleAction: @escaping () -> Void
    ) {
        self.playAction = playAction
        self.shuffleAction = shuffleAction
    }

    public var body: some View {
        HStack(spacing: 20) {
            Button(action: playAction) {
                Image(systemName: "play.fill")
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)

            Button(action: shuffleAction) {
                Image(systemName: "shuffle")
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .frame(height: 40)
    }
}

struct PlayerControlViewPreviews: PreviewProvider {
    static var previews: some View {
        PlayerControlView(
            playAction: { },
            shuffleAction: { }
        )
            .previewLayout(.fixed(width: 375, height: 80))
    }
}
