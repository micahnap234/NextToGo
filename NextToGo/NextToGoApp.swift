//
//  NextToGoApp.swift
//  NextToGo
//
//  Created by Micah Napier on 5/8/2024.
//

import SwiftUI

@main
struct NextToGoApp: App {
    var body: some Scene {
        WindowGroup {
            NextToGoView(viewModel: NextToGoViewModel(raceService: RaceService(), timerPublisher: RealTimerPublisher()))
        }
    }
}
