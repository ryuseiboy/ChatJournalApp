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
    @Binding var journalText: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @State private var date: Date = Date()
    @State private var showDatePicker = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Form{
                    Section("Content") {
                        TextEditor(text:$journalText)
                            .frame(height: 400)
                            
                    }
                }
                
            }
            .navigationTitle(formattedDate)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                /*ToolbarItem(placement: .) {
                    HStack {
                        Text(formattedDate)
                            .font(.headline)
                            .onTapGesture {
                                showDatePicker.toggle()
                            }
                    }
                    .background(.red)
                }*/
                
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
                    Button("完了") {
                        // ボタンのアクション
                        saveJournal()
                        isPresentedB = false
                    }
                    .foregroundColor(.blue) // ボタンのテキスト色
                }
            }
            .sheet(isPresented: $showDatePicker) {
                CustomDatePickerView(selectedDate: $date, isPresented: $showDatePicker)
                    .presentationDetents([.fraction(0.7)])
            }

        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 E曜日" // フォーマットを指定
        formatter.locale = Locale(identifier: "ja_JP") // ロケールを日本語に設定
        return formatter.string(from: date)
    }
    
    private func saveJournal() {
        let data = Journal(date: date, text: journalText)
        context.insert(data)
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
            .navigationBarTitle(Text(formattedDate))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 E曜日" // フォーマットを指定
        formatter.locale = Locale(identifier: "ja_JP") // ロケールを日本語に設定
        return formatter.string(from: selectedDate)
    }
}

#Preview {
    DiaryEntryDetailView(isPresentedB: .constant(true),journalText: .constant(""))
}
