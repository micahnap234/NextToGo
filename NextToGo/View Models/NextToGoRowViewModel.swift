//
//  NextToGoRowViewModel.swift
//  NextToGo
//
//  Created by Micah Napier on 5/8/2024.
//

import SwiftUI
import Combine

class NextToGoRowViewModel: ObservableObject, Identifiable {
    @Published var countdown: String = ""
    
    private let category: RacingCategory
    private var timer: AnyCancellable?
    private let timerPublisher: TimerPublishing
    private let raceSummary: RaceSummary
    
    var meetingDisplayTitle: String {
        return "\(raceSummary.meetingName) - R\(raceSummary.raceNumber)"
    }
    
    var categoryDisplayTitle: String {
        return category.name
    }

    init(raceSummary: RaceSummary, timerPublisher: TimerPublishing = RealTimerPublisher()) {
        self.raceSummary = raceSummary
        self.category = RacingCategory(categoryId: raceSummary.categoryID)
        self.timerPublisher = timerPublisher
        updateCountdown()
        startCountdown()
    }
    
    private func startCountdown() {
        timer = timerPublisher.timerPublisher(every: 1, on: .main, in: .common)
            .sink { [weak self] _ in
                self?.updateCountdown()
            }
    }
    
    private func updateCountdown() {
        let currentTime = Int(Date().timeIntervalSince1970)
        let timeInterval = raceSummary.advertisedStart.seconds - currentTime
        countdown = "\(timeInterval / 60)m \(timeInterval % 60)s"
    }
    
    deinit {
        timer?.cancel()
    }
}

