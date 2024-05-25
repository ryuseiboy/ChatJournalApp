//
//  ChatView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/08.
//

import SwiftUI
import GoogleGenerativeAI



struct ChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text:String = ""
    @State private var isCompleting: Bool = false
    @Binding var isPresentedChat: Bool
    @Binding var isPresentedB: Bool
    @Binding var journalText: String
    let modelName = "gemini-1.5-flash"
    let config = GenerationConfig(
      maxOutputTokens: 100
    )
    //@State private var history:[ChatMessage] = [ChatMessage(role: .system, content: "今日は良い日でしたか？")]
    @State private var history:[ModelContent] = []
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    Button(action: {
                        // ボタンが押されたときのアクションをここに記述
                        print("Button tapped")
                        //isPresentedChat.toggle()
                        Task{
                            await makeJournal(to: &history, outputText: &journalText, modelName: modelName)
                        }
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "square.and.pencil") // アイコン
                                .foregroundColor(.white) // アイコンの色
                            Text("完成") // ボタンのテキスト
                                .foregroundColor(.white) // テキストの色
                        }
                        .frame(maxWidth: .infinity) // ボタンを画面幅いっぱいに広げる
                        .padding() // パディングを追加
                        .background(Color(#colorLiteral(red: 0.2078431373, green: 0.7647058824, blue: 0.3450980392, alpha: 1))) // バックグラウンドカラー
                        .cornerRadius(10) // 角を丸くする
                    }
                    .padding(.horizontal) //ボタンの水平方向のパディングを追加

                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(history.indices, id: \.self) { index in
                                    if index > 0 {
                                        MessageView(message: history[index])
                                            .id(index)
                                    }
                                }
                            }
                            .onChange(of: history.count) { _ in
                                if !history.isEmpty {
                                    proxy.scrollTo(history.count - 1, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    // テキスト入力フィールドと送信ボタンの表示
                    HStack {
                        // テキスト入力フィールド
                        TextField("メッセージを入力", text: $text)
                            .disabled(isCompleting) // チャットが完了するまで入力を無効化
                            .font(.system(size: 15)) // フォントサイズを調整
                            .padding(8)
                            .padding(.horizontal, 10)
                            .background(Color(.systemBackground)) // 入力フィールドの背景色を白に設定
                            .foregroundColor(Color(.label))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)

                            )
                        
                        // 送信ボタン
                        Button(action: {
                            isCompleting = true
                            // ユーザーのメッセージをチャットに追加
                            let tmp = text
                             // テキストフィールドをクリア
                            Task {
                                await runGemini(to: &history, txt: tmp, modelName: modelName)
                                isCompleting = false
                                text = ""
                            }
                        
                        }) {
                            // 送信ボタンのデザイン
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(self.text == "" ? Color(#colorLiteral(red: 0.75, green: 0.95, blue: 0.8, alpha: 1)) : Color(#colorLiteral(red: 0.2078431373, green: 0.7647058824, blue: 0.3450980392, alpha: 1)))
                        }
                        // テキストが空またはチャットが完了していない場合はボタンを無効化
                        .disabled(self.text == "" || isCompleting)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8) // 下部のパディングを調整
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
                .onAppear(){
                    journalText = ""
                }
            }
            .onAppear(){
                Task {
                    await runGemini(to: &history, txt: "あなたはuserに対してフレンドリーに接してください。会話を始めましょう！",modelName: modelName)
                }
            }
        }
    }
    

    func runGemini(to chatHistory: inout [ModelContent],txt:String,modelName:String) async {
        // モデルの準備
        let model = GenerativeModel(
            name: modelName,
            apiKey: APIKey.default,
            systemInstruction: "## Role ##\n会話は全て日本語で行います\nYour role is to support me in writing a diary entry.\nYour goal is to complete the diary entry based on our conversation.\nPlease ensure to empathize with and affirm the other party.\n\n## Instructions ##\nFollow the instructions below from 1 to 8 step by step, executing and responding to one item at a time.\nYou should not execute multiple instructions at once.\nYou should not aim to achieve the goal in a single interaction.\n\n1. Ask the other party if they had a good day with a closed-ended question.\n\n2. Ask me what happened today.\n\n3. Based on my response, ask further questions to delve deeper into the topic. You should ask a maximum of 3 follow-up questions per topic. Do not execute multiple questions at once.\n\n4. Ask if anything else happened today.\n\n5. Based on my response, ask further questions to delve deeper into the topic. You should ask a maximum of 3 follow-up questions per topic. Do not execute multiple questions at once.\n\n6. Confirm if there were any other events today.\n\n7. If there were, ask further questions to delve deeper into the topic. You should ask a maximum of 3 follow-up questions per topic. Do not execute multiple questions at once. If there were no other events, instruct me to press the \"Diary\" button.\n\n8. When you receive the message \"会話の内容をもとに日記を生成してください。,\" summarize our conversation and create a diary-like entry. Use an advanced vocabulary, similar to that of a top-notch novelist, rather than merely repeating my words.\n"
        )
        
        let history = chatHistory
        // チャットの準備
        let chat = model.startChat(history: history)
        
        do {
            // 質問応答 (1ターン目)
            let response1 = try await chat.sendMessage(txt)
            if let text = response1.text {
                print(text)
                chatHistory.append(ModelContent(role: Optional("user"), parts:[ModelContent.Part.text(txt)]))
                chatHistory.append(ModelContent(role: Optional("model"), parts:[ModelContent.Part.text(text)]))
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func makeJournal(to chatHistory: inout [ModelContent], outputText: inout String, modelName: String) async {
        // モデルの準備
        let model = GenerativeModel(
            name: "gemini-1.5-flash-latest",
            apiKey: APIKey.default,
            systemInstruction: "## Role ##\n会話は全て日本語で行います\nYour role is to support me in writing a diary entry.\nYour goal is to complete the diary entry based on our conversation.\nPlease ensure to empathize with and affirm the other party.\n\n## Instructions ##\nFollow the instructions below from 1 to 8 step by step, executing and responding to one item at a time.\nYou should not execute multiple instructions at once.\nYou should not aim to achieve the goal in a single interaction.\n\n1. Ask the other party if they had a good day with a closed-ended question.\n\n2. Ask me what happened today.\n\n3. Based on my response, ask further questions to delve deeper into the topic. You should ask a maximum of 3 follow-up questions per topic. Do not execute multiple questions at once.\n\n4. Ask if anything else happened today.\n\n5. Based on my response, ask further questions to delve deeper into the topic. You should ask a maximum of 3 follow-up questions per topic. Do not execute multiple questions at once.\n\n6. Confirm if there were any other events today.\n\n7. If there were, ask further questions to delve deeper into the topic. You should ask a maximum of 3 follow-up questions per topic. Do not execute multiple questions at once. If there were no other events, instruct me to press the \"Diary\" button.\n\n8. When you receive the message \"会話の内容をもとに日記を生成してください。,\" summarize our conversation and create a diary-like entry. Use an advanced vocabulary, similar to that of a top-notch novelist, rather than merely repeating my words.\n"

        )
        
        let history = chatHistory
        // チャットの準備
        let chat = model.startChat(history: history)
        
        do {
            // 質問応答 (1ターン目)
            let response1 = try await chat.sendMessage("会話の内容をもとに日記を生成してください。")
            if let text = response1.text {
                print(text)
                outputText = text
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

struct MessageView: View {
    var message: ModelContent
    
    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer()
            } else {
                // ユーザーでない場合はアバターを表示
                AvatarView(imageName: "avatar")
                    .padding(.trailing, 8)
            }
            VStack(alignment: .leading, spacing: 4) {
                // メッセージのテキストを表示
                Text(message.parts[0].text ?? "")
                    .font(.system(size: 14)) // フォントサイズを調整
                    .foregroundColor(message.role == "user" ? .white : .black)
                    .padding(10)
                // ユーザーとAIのメッセージで背景色を変更
                    .background(message.role == "user" ? Color(#colorLiteral(red: 0.2078431373, green: 0.7647058824, blue: 0.3450980392, alpha: 1)) : Color(#colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9176470588, alpha: 1)))
                    .cornerRadius(20) // 角を丸くする
            }
            .padding(.vertical, 5)
            // ユーザーのメッセージの場合は右側にスペースを追加
            if message.role != "user" {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
}

// アバタービュー
struct AvatarView: View {
    var imageName: String
    
    var body: some View {
        VStack {
            // アバター画像を円形に表示
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            
            // AIの名前を表示
            Text("AI")
                .font(.caption) // フォントサイズを小さくするためのオプションです。
                .foregroundColor(.black) // テキストの色を黒に設定します。
        }
    }
}

#Preview {
        ChatView(isPresentedChat: .constant(true), isPresentedB: .constant(true),journalText: .constant(""))
}
