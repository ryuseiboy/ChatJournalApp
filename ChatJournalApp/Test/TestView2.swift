//
//  TestView2.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/10.
//

import SwiftUI
import GoogleGenerativeAI

struct TestView2: View {
    var body: some View {
        VStack {
            Button("Run Gemini") {
                Task {
                    await runGemini()
                }
            }
        }
        .padding()
    }
        
    func runGemini() async {
        // モデルの準備
        let model = GenerativeModel(
            name: "models/gemini-pro",
            apiKey: APIKey.default
        )
        let history:[ModelContent] = [
            ModelContent(role: Optional("user"), parts:[ModelContent.Part.text("部屋に犬が1匹、猫が2匹います。")]),
            ModelContent(role: Optional("model"), parts:[ModelContent.Part.text("把握しました。何が知りたいですか？")])
        ]
        // チャットの準備
        let chat = model.startChat(history: history)
        
        print("文章が出るはず\(history[0].parts[0].text ?? "")")
        
        do {
            // 質問応答 (1ターン目)
            let response1 = try await chat.sendMessage("部屋に動物は何匹いる？")
            if let text = response1.text {
                print(text)
            }
            
            // 質問応答 (2ターン目)
            let response2 = try await chat.sendMessage("犬と猫どっちが多い？")
            if let text = response2.text {
                print(text)
            }
            
            // 会話履歴の表示
            print(chat.history)
        } catch {
            print("Error: \(error)")
        }
    }
}

#Preview {
    TestView2()
}
