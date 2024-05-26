//
//  UpdateJournalView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/26.
//

import SwiftUI
import SwiftData

struct UpdateJournalView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var journal: Journal
    
    var body: some View {
        Form {
            Section("Date") {
                DatePicker(selection: $journal.date, displayedComponents: .date) {
                    Text("日付")
                }
            }
            
            Section("Content") {
                TextEditor(text: $journal.text)
                    .frame(height: 400)
            }
        }
        .navigationTitle("日記の更新")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("更新"){
                    updateJournal()
                    dismiss()
                }
            }
        }
    }
    
    private func updateJournal() {
        try? context.save()
    }
}

#Preview {
    //UpdateJournalView()
    ContentView()
        .modelContainer(for: Journal.self)
}
