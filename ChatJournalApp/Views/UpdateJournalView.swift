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
    @State private var showDatePicker = false
    
    var body: some View {
        Form {
            Section("Content") {
                TextEditor(text: $journal.text)
                    .frame(height: 400)
            }
        }
        .navigationTitle(formattedDate)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showDatePicker.toggle()
                }) {
                    Image(systemName: "chevron.down")
                        //.font(.largeTitle) // アイコンのサイズ調整
                        .foregroundColor(.black) // アイコンの色
                        .padding(.trailing, 29.0)
                        //.padding() // パディングでアイコン周りの余白を調整
                        //.background(Color.green) // 背景色
                        //.clipShape(Circle()) // 円形にクリップ
                        //.shadow(radius: 10) // 影を追加
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("更新"){
                    updateJournal()
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            CustomDatePickerView(selectedDate: $journal.date, isPresented: $showDatePicker)
                .presentationDetents([.fraction(0.7)])
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 E曜日" // フォーマットを指定
        formatter.locale = Locale(identifier: "ja_JP") // ロケールを日本語に設定
        return formatter.string(from: journal.date)
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
