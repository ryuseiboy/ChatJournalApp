//
//  ChatJournalAppApp.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/08.
//

import SwiftUI

@main
struct ChatJournalAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Journal.self)
    }
}
