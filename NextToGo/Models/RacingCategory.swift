//
//  RacingCategory.swift
//  NextToGo
//
//  Created by Micah Napier on 6/8/2024.
//

import Foundation

enum RacingCategory {
    case harness
    case greyhound
    case horses
    case unknown

    init(categoryId: String) {
        switch categoryId {
        case "161d9be2-e909-4326-8c2c-35ed71fb460b":
            self = .harness
        case "9daef0d7-bf3c-4f50-921d-8e818c60fe61":
            self = .greyhound
        case "4a2788f8-e825-4d36-9894-efd4baf1cfae":
            self = .horses
        default:
            self = .unknown
        }
    }

    var name: String {
        switch self {
        case .harness:
            return "Harness"
        case .greyhound:
            return "Greyhound"
        case .horses:
            return "Horses"
        case .unknown:
            return "Unknown"
        }
    }
}
