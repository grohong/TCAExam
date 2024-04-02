//
//  PlayingState.swift
//
//
//  Created by Hong Seong Ho on 4/2/24.
//

import Foundation

public struct PlayingState: Equatable {

    public let isPlaying: Bool
    public let currentTimeInSeconds: Float64
    public let durationInSeconds: Float64

    public var period: Double { currentTimeInSeconds / durationInSeconds }

    public init(
        isPlaying: Bool,
        currentTimeInSeconds: Float64,
        durationInSeconds: Float64
    ) {
        self.isPlaying = isPlaying
        self.currentTimeInSeconds = currentTimeInSeconds
        self.durationInSeconds = durationInSeconds
    }
}
