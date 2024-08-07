//
//  MockRaceService.swift
//  NextToGoTests
//
//  Created by Micah Napier on 7/8/2024.
//

import Combine
import Foundation
@testable import NextToGo

struct MockRaceService: RaceDataFetching {
    let raceSummaries: [RaceSummary]
    
    init(raceSummaries: [RaceSummary]) {
        self.raceSummaries = raceSummaries
    }
    
    func fetchRaceSummaries(numberOfRaces: Int) async throws -> RacingData {
        let response = RacingData(raceSummaries: Dictionary(uniqueKeysWithValues: raceSummaries.map { ($0.raceID, $0) }))
        return response
    }
}

struct MockTimerPublisher: TimerPublishing {
    private let subject = PassthroughSubject<Date, Never>()

    func timerPublisher(every interval: TimeInterval, on runLoop: RunLoop, in mode: RunLoop.Mode) -> AnyPublisher<Date, Never> {
        Timer.publish(every: interval, on: runLoop, in: mode)
            .autoconnect()
            .eraseToAnyPublisher()
    }

    // Manually trigger the timer
    func trigger() {
        subject.send(Date())
    }
}


