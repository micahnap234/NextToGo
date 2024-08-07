//
//  NextToGoRowViewModelTests.swift
//  NextToGoTests
//
//  Created by Micah Napier on 7/8/2024.
//

import XCTest
import Combine
@testable import NextToGo

class NextToGoRowViewModelTests: XCTestCase {
    var mockTimerPublisher: MockTimerPublisher!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockTimerPublisher = MockTimerPublisher()
    }

    override func tearDown() {
        mockTimerPublisher = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialCountdownState() {
        let raceSummary = RaceSummary(raceID: "1", raceNumber: 1, meetingName: "Meeting1", categoryID: "1", advertisedStart: .init(seconds: Int(Date().timeIntervalSince1970) + 3600)) // 1 hour into the future
        let viewModel = NextToGoRowViewModel(raceSummary: raceSummary, timerPublisher: mockTimerPublisher)
        XCTAssertEqual(viewModel.countdown, "60m 0s", "Initial countdown should be set correctly based on the race start time.")
    }

    func testCountdownUpdateOnTimerTrigger() {
        let raceSummary = RaceSummary(raceID: "1", raceNumber: 1, meetingName: "Meeting1", categoryID: "1", advertisedStart: .init(seconds: Int(Date().timeIntervalSince1970) + 3600)) // 1 hour into the future
        let viewModel = NextToGoRowViewModel(raceSummary: raceSummary, timerPublisher: mockTimerPublisher)
        
        let expectation = XCTestExpectation(description: "Countdown updates on timer trigger")
        
        var cancellables = Set<AnyCancellable>()
        
        // Trigger the timer manually
        mockTimerPublisher.timerPublisher(every: 1, on: .main, in: .common)
            .sink { _  in
                viewModel.$countdown
                    .dropFirst()
                    .sink { countdown in
                        XCTAssertEqual(countdown, "59m 58s", "Countdown should decrement by one second.")
                        expectation.fulfill()
                    }.store(in: &cancellables)
            }.store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }
    
    func testContinuousCountdownDecrement() {
        let raceSummary = RaceSummary(raceID: "1", raceNumber: 1, meetingName: "Meeting1", categoryID: "1", advertisedStart: .init(seconds: Int(Date().timeIntervalSince1970) + 3600)) // 1 hour into the future
        let viewModel = NextToGoRowViewModel(raceSummary: raceSummary, timerPublisher: mockTimerPublisher)
        
        let initialTime = viewModel.countdown
        let numberOfTicks = 3
        let expectation = XCTestExpectation(description: "Countdown decrements continuously")
        expectation.expectedFulfillmentCount = numberOfTicks

        viewModel.$countdown
            .dropFirst()
            .sink { countdown in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        for _ in 0..<numberOfTicks {
            mockTimerPublisher.trigger()
        }

        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotEqual(viewModel.countdown, initialTime, "Countdown should have decremented.")
    }
}

