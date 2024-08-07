//
//  ContentView.swift
//  NextToGo
//
//  Created by Micah Napier on 5/8/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NextToGoView(viewModel: NextToGoViewModel())
    }
}

#Preview {
    ContentView()
}
