//
//  ChatView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/08.
//

import SwiftUI
import GoogleGenerativeAI



struct ChatView: View {
    @Binding var isPresentedChat: Bool
    @Binding var isPresentedB: Bool
    let config = GenerationConfig(
      maxOutputTokens: 100
    )
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    Button(action: {
                        // ボタンが押されたときのアクションをここに記述
                        print("Button tapped")
                        isPresentedChat.toggle()
                    }) {
                        HStack {
                            Image(systemName: "square.and.pencil") // アイコン
                                .foregroundColor(.white) // アイコンの色
                            Text("完成") // ボタンのテキスト
                                .foregroundColor(.white) // テキストの色
                        }
                        .frame(maxWidth: .infinity) // ボタンを画面幅いっぱいに広げる
                        .padding() // パディングを追加
                        .background(Color.blue) // バックグラウンドカラー
                        .cornerRadius(10) // 角を丸くする
                    }
                    .padding(.horizontal) // ボタンの水平方向のパディングを追加
                    Spacer()
                }
                .navigationBarItems(leading: // ナビゲーションバーの左側にボタンを配置
                                    Button("キャンセル") { // ボタンに表示されるテキストとアクション
                    // ボタンのアクション
                    isPresentedB = false
                    isPresentedChat.toggle()
                    
                    print(isPresentedB)
                }
                    .foregroundColor(.blue) // ボタンのテキスト色
                )
                .interactiveDismissDisabled()
            }
        }
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(isPresentedChat: .constant(true), isPresentedB: .constant(true))
    }
}
