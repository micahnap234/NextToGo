//
//  NextToGoViewModel.swift
//  NextToGo
//
//  Created by Micah Napier on 6/8/2024.
//
import SwiftUI
import Combine

/// A view model for managing the state and logic of the Next to Go View.
class NextToGoViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published private(set) var raceSummaries: [NextToGoRowViewModel] = []
    
    private let fetchCount: Int
    let navigationTitle = "Next to Go"
    private let raceService: RaceDataFetching
    private var timer: AnyCancellable?
    private let timerPublisher: TimerPublishing
    
    /// Initializes the view model with dependencies.
    /// - Parameters:
    ///   - raceService: A service to fetch race data.
    ///   - fetchCount: The number of races to fetch.
    ///   - timerPublisher: A timer publisher to schedule periodic updates.
    init(raceService: RaceDataFetching = RaceService(), fetchCount: Int = 10, timerPublisher: TimerPublishing = RealTimerPublisher()) {
        self.raceService = raceService
        self.fetchCount = fetchCount
        self.timerPublisher = timerPublisher
        fetchRaces()
        startTimer()
    }
    
    /// Starts a timer that periodically fetches race data.
    private func startTimer() {
        timer = timerPublisher.timerPublisher(every: 30, on: .main, in: .common)
            .sink { [weak self] _ in
                self?.fetchRaces()
            }
    }
    
    /// Fetches races from the service and updates the view model state.
    private func fetchRaces() {
        isLoading = true
        Task {
            do {
                let fetchedRaces = try await raceService.fetchRaceSummaries(numberOfRaces: fetchCount).raceSummaries.values
                let currentTime = Int(Date().timeIntervalSince1970)
                
                // Filtering and sorting
                let validRaces = fetchedRaces.filter { $0.advertisedStart.seconds > currentTime - 60 }
                let sortedRaces = validRaces.sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }
                let viewModels = sortedRaces.map { NextToGoRowViewModel(raceSummary: $0, timerPublisher: RealTimerPublisher()) }.prefix(5)
                
                // Update on main thread
                await MainActor.run {
                    self.raceSummaries = Array(viewModels)
                    self.isLoading = false
                }
            } catch {
                print("Failed to fetch races: \(error)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    /// Cancels the timer when the view model is deinitialized.
    deinit {
        timer?.cancel()
    }
}
