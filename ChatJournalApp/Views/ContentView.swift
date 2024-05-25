//
//  ContentView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/08.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query private var journals: [Journal]
    @State private var isPresentedChat = false
    @State private var isPresentedB = false
    @State private var journalText:String = ""

    var body: some View {
        NavigationStack{
            ZStack{
                List{
                    JournalListView()
                }
                .listStyle(PlainListStyle())
                // リストのスタイルをプレーンに設定 // リストの背景を透明に設定
                
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // ボタンがタップされた時のアクション
                            isPresentedB.toggle()
                            isPresentedChat.toggle()
                        }) {
                            Image(systemName: "plus")
                                .font(.largeTitle) // アイコンのサイズ調整
                                .foregroundColor(.white) // アイコンの色
                                .padding() // パディングでアイコン周りの余白を調整
                                .background(Color.green) // 背景色
                                .clipShape(Circle()) // 円形にクリップ
                                .shadow(radius: 10) // 影を追加
                        }
                        .padding() // ボタン自体の余白を調整
                    }
                }
            }
            .navigationTitle("ジャーナル")
            .sheet(isPresented: $isPresentedChat) {
                ChatView(isPresentedChat: $isPresentedChat, isPresentedB: $isPresentedB, journalText: $journalText)
            }
            .sheet(isPresented: $isPresentedB) {
                DiaryEntryDetailView(isPresentedB: $isPresentedB, journalText: $journalText)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Journal.self)
}
