//
//  NextToGoView.swift
//  NextToGo
//
//  Created by Micah Napier on 5/8/2024.
//

import SwiftUI

struct NextToGoView: View {
    @ObservedObject var viewModel: NextToGoViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .navigationTitle(viewModel.navigationTitle)
                } else {
                    List(viewModel.raceSummaries) { race in
                        NextToGoRow(viewModel: race)
                    }
                    .navigationTitle(viewModel.navigationTitle)
                }
            }
        }
    }
}

#Preview {
    Group {
        NextToGoView(viewModel: NextToGoViewModel())
            .environment(\.sizeCategory, .extraExtraExtraLarge)
        
        NextToGoView(viewModel: NextToGoViewModel())
            .environment(\.sizeCategory, .small)
    }
}


