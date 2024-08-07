//
//  NextToGoRow.swift
//  NextToGo
//
//  Created by Micah Napier on 5/8/2024.
//

import SwiftUI

struct NextToGoRow: View {
    @ObservedObject var viewModel: NextToGoRowViewModel
    
    var body: some View {
      HStack() {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(viewModel.meetingDisplayTitle)
                .font(.headline)
            Text(viewModel.categoryDisplayTitle)
                .font(.subheadline)
        }
          Spacer()
          Text(viewModel.countdown)
              .font(.caption)
      }
    }
}

#Preview {
    NextToGoRow(viewModel: NextToGoRowViewModel(raceSummary: RaceSummary.mockData(startTime: 3300)))
}
