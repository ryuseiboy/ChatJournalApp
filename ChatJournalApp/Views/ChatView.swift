//
//  ChatView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/08.
//

import SwiftUI
import GoogleGenerativeAI



struct ChatView: View {
    @State private var text:String = ""
    @State private var isCompleting: Bool = false
    @Binding var isPresentedChat: Bool
    @Binding var isPresentedB: Bool
    let config = GenerationConfig(
      maxOutputTokens: 100
    )
    //@State private var history:[ChatMessage] = [ChatMessage(role: .system, content: "今日は良い日でしたか？")]
    @State private var history:[ModelContent] = [ModelContent(role: "model", parts: "今日は良い日でしたか？")]
    
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
                        .background(Color(#colorLiteral(red: 0.2078431373, green: 0.7647058824, blue: 0.3450980392, alpha: 1))) // バックグラウンドカラー
                        .cornerRadius(10) // 角を丸くする
                    }
                    .padding(.horizontal) //ボタンの水平方向のパディングを追加
                    ScrollView {
                        VStack(alignment: .leading){
                            ForEach(history.indices, id: \.self) { index in
                                MessageView(message: history[index])
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
                            .background(Color.white) // 入力フィールドの背景色を白に設定
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)

                            )
                        
                        // 送信ボタン
                        Button(action: {
                            //isCompleting = true
                            // ユーザーのメッセージをチャットに追加
                            self.history.append(ModelContent(role: "user", parts: text))
                            var tmp = text
                            text = "" // テキストフィールドをクリア
                            print("tmp\(tmp)")
                            print("text\(text)")
                            
                            let model = GenerativeModel(
                                name: "gemini-pro",
                                apiKey: APIKey.default,
                                generationConfig: config
                            )
                            
                            let chat = model.startChat(history: history)
                            Task{
                                do {
                                    // OpenAIの設定
                                    let response = try await chat.sendMessage(tmp)
                                    // チャットの生成
                                    
                                    //isCompleting = false
                                    // AIのレスポンスをチャットに追加
                                    if let gemini_text = response.text {
                                        self.history.append(ModelContent(role: "model", parts: gemini_text))
                                    }
                                } catch {
                                    print("ERROR DETAILS - \(error)")
                                }
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
            }
        }
    }
    

    /*func runGemini(history: [ModelContent]) async {
        //isCompleting = true
        // ユーザーのメッセージをチャットに追加
        self.history.append(ModelContent(role: "user", parts: text))
        var tmp = text
        text = "" // テキストフィールドをクリア
        print("tmp\(tmp)")
        print("text\(text)")
        
        let model = GenerativeModel(
            name: "gemini-pro",
            apiKey: APIKey.default,
            generationConfig: config
        )
        
        let chat = model.startChat(history: history)
        
        do {
            // OpenAIの設定
            let response = try await chat.sendMessage(tmp)
            // チャットの生成
            
            //isCompleting = false
            // AIのレスポンスをチャットに追加
            if let gemini_text = response.text {
                self.history.append(ModelContent(role: "model", parts: gemini_text))
            }
        } catch {
            print("ERROR DETAILS - \(error)")
        }
    }*/
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
                Text(extractText(from: message))
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
    
    func extractText(from modelContent: ModelContent) -> String {
        return modelContent.parts.compactMap { part -> String? in
            switch part {
            case .text(let text):
                return text
            default:
                return nil
            }
        }.joined(separator: " ")
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

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(isPresentedChat: .constant(true), isPresentedB: .constant(true))
    }
}
