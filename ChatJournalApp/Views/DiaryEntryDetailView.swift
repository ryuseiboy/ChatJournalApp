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
    @State private var showDatePicker = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Text(journalText)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(formattedDate)
                            .font(.headline)
                            .onTapGesture {
                                showDatePicker.toggle()
                            }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完了") {
                        // ボタンのアクション
                        isPresentedB = false
                    }
                    .foregroundColor(.blue) // ボタンのテキスト色
                }
            }
            .sheet(isPresented: $showDatePicker) {
                CustomDatePickerView(selectedDate: $date, isPresented: $showDatePicker)
                .presentationDetents([.fraction(0.7)])            }

        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 E曜日" // フォーマットを指定
        formatter.locale = Locale(identifier: "ja_JP") // ロケールを日本語に設定
        return formatter.string(from: date)
    }
}

struct CustomDatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "カスタムの日付を設定",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding()

                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("キャンセル")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("完了")
                            .bold()
                    }
                }
                .padding()
            }
            .navigationBarTitle(Text(formattedDate), displayMode: .inline)
        }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 E曜日" // フォーマットを指定
        formatter.locale = Locale(identifier: "ja_JP") // ロケールを日本語に設定
        return formatter.string(from: selectedDate)
    }
}

struct DiaryEntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryEntryDetailView(isPresentedB: .constant(true),journalText: "日記の内容")
    }
}
