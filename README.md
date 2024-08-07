# Next to Go Races App

## Overview
This SwiftUI application displays upcoming races, allowing users to see a countdown until each race starts. It fetches race data from a remote API and updates dynamically.

## Features
- **Dynamic Updates**: Utilizes timers to fetch the latest races every 30 seconds.
- **Asynchronous API Calls**: Fetches data asynchronously from the "Neds" API.
- **Countdown Timer**: Each race row has a countdown timer that updates every second.

## Architecture

The app follows the MVVM (Model-View-ViewModel) pattern.

### Model

- `RaceSummary`: Represents a race and all details required to populate a race.

### ViewModel

- `NextToGoViewModel`: Manages a list of `NextToGoRowViewModel` instances by filtering out races that are 1 minute past the start time and sorting by advertised start time in ascending order. It fetches 10 races from the API and delivers 5 to the user as per business requirements. The reason for fetching 10 races is to potentially backfill races in the event more than 1 have been filtered out.

- `NextToGoRowViewModel`: Manages the data for a single race row, including the countdown timer.

### View

- `NextToGoView`: Displays a list of `NextToGoRow` views.
- `NextToGoRow`: Displays the meeting name, racing category, and a countdown from the advertised start time for a single race.

## Getting Started
### Prerequisites
- Xcode 12 or later
- iOS 15.2 or later

### Running the Application
1. Open `NextToGoRaces.xcodeproj` in Xcode.
2. Choose a target device or simulator.
3. Hit "Run" to build and run the application.

## Testing
The app includes unit tests for ViewModel logic and API interactions. Run the tests via Xcode's Test navigator.

## Future Enhancements
- Add error handling with user-friendly error messages
- Add filtering for specific racing categories
- Auto-refresh more gracefully
