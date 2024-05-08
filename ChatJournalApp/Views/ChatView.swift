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
                    .padding(.horizontal) // ボタンの水平方向のパディングを追加
                    Spacer()
                    
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
                            isCompleting = true
                            // ユーザーのメッセージをチャットに追加
                            //chat.append(ChatMessage(role: .user, content: text))
                            text = "" // テキストフィールドをクリア
                            
                            Task {
                                do {
                                    // OpenAIの設定
                                    
                                    // チャットの生成
                                    
                                    isCompleting = false
                                    // AIのレスポンスをチャットに追加
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
    
    func runGemini() async {
        // モデルの準備
        let model = GenerativeModel(
            name: "gemini-pro",
            apiKey: APIKey.default,
            generationConfig: config
        )
        
        let chat = model.startChat(history: [])
        // 推論の実行
        do {
            let response = try await model.generateContent("日本一高い山は？")
            if let text = response.text {
                print(text)
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(isPresentedChat: .constant(true), isPresentedB: .constant(true))
    }
}
