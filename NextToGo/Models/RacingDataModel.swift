//
//  RacingDataModel.swift
//  NextToGo
//
//  Created by Micah Napier on 6/8/2024.
//

import Foundation

struct RacingResponse: Decodable {
    let status: Int
    let data: RacingData
}

struct RacingData: Decodable {
    let raceSummaries: [String: RaceSummary]
    
    enum CodingKeys: String, CodingKey {
        case raceSummaries = "race_summaries"
    }
}

struct RaceSummary: Decodable {
    let raceID: String
    let raceNumber: Int
    let meetingName: String
    let categoryID: String
    let advertisedStart: AdvertisedStart
    
    enum CodingKeys: String, CodingKey {
        case raceID = "race_id"
        case raceNumber = "race_number"
        case meetingName = "meeting_name"
        case categoryID = "category_id"
        case advertisedStart = "advertised_start"
    }
}

struct AdvertisedStart: Decodable {
    let seconds: Int
}

extension RaceSummary {
    static func mockData(startTime: Int) -> Self {
        return RaceSummary(raceID: "\(Int.random(in: 1...999))", raceNumber: 2, meetingName: "Mock Meeting Name", categoryID: "161d9be2-e909-4326-8c2c-35ed71fb460b", advertisedStart: AdvertisedStart(seconds: startTime))
    }
}
