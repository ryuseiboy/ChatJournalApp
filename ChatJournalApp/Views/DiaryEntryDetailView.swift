//
//  CheckDirayView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/08.
//

import SwiftUI
import SwiftData

struct DiaryEntryDetailView: View {
    @Binding var isPresentedB: Bool
    var journalText: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationStack{
            VStack{
                Text(journalText)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DatePicker(
                        "Select Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完了") {
                        // ボタンのアクション
                        isPresentedB = false
                    }
                    .foregroundColor(.blue) // ボタンのテキスト色
                }
            }
        }
    }
}

struct DiaryEntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryEntryDetailView(isPresentedB: .constant(true),journalText: "日記の内容")
    }
}
