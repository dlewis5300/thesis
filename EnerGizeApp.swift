//
//  EnerGize5App.swift
//  EnerGize5
//
//  Created by D'Mitri Lewis on 4/20/24.
//

import SwiftUI

@main
struct ChatTestApp: App {
    @StateObject private var chatViewModel = ChatViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: chatViewModel)  // Correct instantiation
        }
    }
}
