//
//  RacingService.swift
//  NextToGo
//
//  Created by Micah Napier on 6/8/2024.
//

import Foundation
import Combine

/// A protocol defining the requirements for fetching race summaries from a service.
protocol RaceDataFetching {
    /// Fetches a specified number of race summaries asynchronously.
    /// - Parameter numberOfRaces: The number of race summaries to fetch.
    /// - Returns: An array of `RaceSummary` wrapped in `RacingData`.
    func fetchRaceSummaries(numberOfRaces: Int) async throws -> RacingData
}

/// A service responsible for fetching racing data from a remote server.
struct RaceService: RaceDataFetching {
    private let baseURLString = "https://api.neds.com.au/rest/v1/racing/"
    
    /// Fetches race summaries from the API.
    /// - Parameter numberOfRaces: The number of race summaries to fetch.
    /// - Throws: `URLError.badURL` if URL components can't form a valid URL.
    /// - Returns: A `RacingData` object containing race summaries.
    func fetchRaceSummaries(numberOfRaces: Int) async throws -> RacingData {
        guard var urlComponents = URLComponents(string: baseURLString) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "nextraces"),
            URLQueryItem(name: "count", value: "\(numberOfRaces)")
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let racingResponse = try JSONDecoder().decode(RacingResponse.self, from: data)
        
        return racingResponse.data
    }
}


