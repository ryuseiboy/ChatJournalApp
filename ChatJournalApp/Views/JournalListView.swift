//
//  JournalListView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/17.
//

import SwiftUI
import SwiftData

struct JournalListView: View {
    @Environment(\.modelContext) private var context
    @Query private var journals: [Journal]
    
    
    var body: some View {
        ForEach(journals.indices, id: \.self) { index in
            /*Text(journal.date.formatted())
             .font(.body)
             .frame(maxWidth: .infinity, alignment: .leading)
             .foregroundStyle(.secondary)*/
            /*Text(journal.text)
             .font(.body)
             .frame(maxWidth: .infinity, alignment: .leading)
             .foregroundStyle(.primary)*/
            JournalPreview(diaryText: journals[index].text)
        }
        .onDelete(perform: deleteJournal)
    }
    
    func groupedByMonth(entries: [Journal]) -> [String: [Journal]] {
        let grouped = Dictionary(grouping: entries) { entry in
            entry.date.monthYearString()
        }
        return grouped
    }
    
    private func deleteJournal(at offsets: IndexSet) {
        for offset in offsets {
            let journal = journals[offset]
            context.delete(journal)
        }
    }
    
}

#Preview {
    //JournalListView()
    ContentView()
        .modelContainer(for: Journal.self)
}
