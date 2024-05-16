//
//  JournalListView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/17.
//

import SwiftUI
import SwiftData

struct JournalListView: View {
    @Query private var journals: [Journal]
    var body: some View {
        ForEach(journals) { journal in
            VStack{
                Text(journal.date.formatted())
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.secondary)
                Text(journal.text)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.primary)
            }
        }
    }
}

#Preview {
    JournalListView()
}
