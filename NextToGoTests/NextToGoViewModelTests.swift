import XCTest
import Combine
@testable import NextToGo

class NextToGoViewModelTests: XCTestCase {
    var viewModel: NextToGoViewModel!
    var mockRaceService: MockRaceService!
    var mockTimerPublisher: MockTimerPublisher!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockRaceService = MockRaceService(raceSummaries: []) // Initialize with your desired data
        mockTimerPublisher = MockTimerPublisher()
        viewModel = NextToGoViewModel(raceService: mockRaceService, fetchCount: 10, timerPublisher: mockTimerPublisher)
    }

    override func tearDown() {
        viewModel = nil
        mockRaceService = nil
        mockTimerPublisher = nil
        cancellables = nil
        super.tearDown()
    }

    
    func testInitialLoadingState() {
        XCTAssertTrue(viewModel.isLoading, "ViewModel should be in loading state initially.")
    }

    
    func testFetchRacesSuccessfully() async throws {
        // Given
        let currentTime = Int(Date().timeIntervalSince1970)
        let race1 = RaceSummary(raceID: "1", raceNumber: 1, meetingName: "testMeeting1", categoryID: "testID", advertisedStart: .init(seconds: currentTime + 300)) // Ensures it's a future time
        let race2 = RaceSummary(raceID: "2", raceNumber: 3, meetingName: "testMeeting2", categoryID: "testID", advertisedStart: .init(seconds: currentTime + 400))

        let mockService = MockRaceService(raceSummaries: [race1, race2])

        let viewModel = NextToGoViewModel(raceService: mockService, fetchCount: 5)

        let expectation = XCTestExpectation(description: "Waiting for fetchRaces to complete")
        
        // Using Combine to wait for the update
        var cancellables = Set<AnyCancellable>()
        viewModel.$raceSummaries
            .dropFirst() // Initial empty array is skipped
            .sink { summaries in
                guard !summaries.isEmpty else { return }
                
                XCTAssertEqual(summaries.count, 2)
                XCTAssertEqual(summaries[0].meetingDisplayTitle, "testMeeting1 - R1")
                XCTAssertEqual(summaries[1].meetingDisplayTitle, "testMeeting2 - R3")
                
                viewModel.$isLoading
                    .dropFirst()
                    .sink { isLoading in
                        XCTAssertFalse(isLoading)
                    }
                    .store(in: &cancellables)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        await fulfillment(of: [expectation], timeout: 10.0) // Adjust timeout based on expected time for async operations
    }

    
    func testFetchRacesFailure() async throws {
        // Given
        let mockService = MockRaceService(raceSummaries: [])
        
        // When
        viewModel = NextToGoViewModel(raceService: mockService, fetchCount: 5)
        
        // Wait for the async operation to complete
        try await Task.sleep(nanoseconds: 1 * 1_000_000_000) // Sleep for 1 second
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.raceSummaries.count, 0)
    }
}
