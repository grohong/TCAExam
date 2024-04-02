//
//  PlayingState.swift
//
//
//  Created by Hong Seong Ho on 4/2/24.
//

import Foundation

public struct PlayingState: Equatable {

    public let isPlaying: Bool
    public let period: Double

    public init(isPlaying: Bool, period: Double) {
        self.isPlaying = isPlaying
        self.period = period
    }
}
