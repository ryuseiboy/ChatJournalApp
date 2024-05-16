//
//  TestView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/10.
//

import SwiftUI
import GoogleGenerativeAI 

/*struct TestView: View {
    @State var text = ""
    @State var isCompleting = false
    @State private var chatHistory:[ModelContent] = [ModelContent(role:  "system", parts: "今日は良い日でしたか？")]
    let model = GenerativeModel(
        name: "models/gemini-pro",
        apiKey: APIKey.default
    )

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading){
                    ForEach(chatHistory.indices, id: \.self) { index in
                        MessageView(message: chatHistory[index])
                    }
                }
            }
            HStack{
                TextField("メッセージを入力", text: $text)
                    .disabled(isCompleting) // チャットが完了するまで入力を無効化
                    .font(.system(size: 15)) // フォントサイズを調整
                    .padding(8)
                    .padding(.horizontal, 10)
                    .background(Color.white) // 入力フィールドの背景色を白に設定
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
                        
                    )
                Button(action:{

                }) {
                    // 送信ボタンのデザイン
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(self.text == "" ? Color(#colorLiteral(red: 0.75, green: 0.95, blue: 0.8, alpha: 1)) : Color(#colorLiteral(red: 0.2078431373, green: 0.7647058824, blue: 0.3450980392, alpha: 1)))
                }
                // テキストが空またはチャットが完了していない場合はボタンを無効化
                .disabled(self.text == "" )
            }
        }
        .padding()
    }

}

#Preview {
    TestView()
        .environment(\.colorScheme, .dark)
}*/
