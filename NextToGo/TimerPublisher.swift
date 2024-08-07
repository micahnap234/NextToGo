//
//  TimerPublisher.swift
//  NextToGo
//
//  Created by Micah Napier on 7/8/2024.
//

import Combine
import Foundation

protocol TimerPublishing {
    func timerPublisher(every interval: TimeInterval, on runLoop: RunLoop, in mode: RunLoop.Mode) -> AnyPublisher<Date, Never>
}

struct RealTimerPublisher: TimerPublishing {
    func timerPublisher(every interval: TimeInterval, on runLoop: RunLoop, in mode: RunLoop.Mode) -> AnyPublisher<Date, Never> {
        Timer.publish(every: interval, on: runLoop, in: mode)
            .autoconnect()
            .eraseToAnyPublisher()
    }
}
