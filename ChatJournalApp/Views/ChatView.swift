//
//  ChatView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/08.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text:String = ""
    @State private var isCompleting: Bool = false
    @Binding var isPresentedChat: Bool
    @Binding var isPresentedB: Bool
    @Binding var journalText: String
    @State private var prompt: String = ""
    @State private var responseText: String?
    @State private var history:[ChatMessage] = []
    @State private var chatStart:Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    Button(action: {
                        // ボタンが押されたときのアクションをここに記述
                        print("Button tapped")
                        //isPresentedChat.toggle()
                        Task{
                            do {
                                await generateText(prompt:"Make it diary."){ response in
                                        journalText = response
                                    }
                            }
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
                                    if history[index].content != nil {
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
                            history.append(ChatMessage(role: .user, content: text))
                            print(tmp)
                            Task{
                                do{
                                    await generateText(prompt: tmp) { response in
                                        responseText = response
                                        history.append(ChatMessage(role: .assistant, content: responseText))
                                    }
                                    isCompleting = false
                                    text = ""
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
            .onAppear(){
                Task {
                    do {
                        await generateText(prompt: "会話を始めよう！") { response in
                            responseText = response
                            history.append(ChatMessage(role: .assistant, content: responseText))
                        }
                    }
                }
                journalText = ""
            }
        }
    }
    

    func generateText(prompt: String, completion: @escaping (String) -> Void) async {
        guard let url = URL(string: "http://127.0.0.1:5000/api/generate") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["prompt": prompt]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let text = jsonResponse["text"] as? String {
                    DispatchQueue.main.async {
                        completion(text)
                    }
                } else if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let error = jsonResponse["error"] as? String {
                    DispatchQueue.main.async {
                        completion(error)
                    }
                }
            }
        }.resume()
    }
    
}

struct MessageView: View {
    var message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            } else {
                // ユーザーでない場合はアバターを表示
                AvatarView(imageName: "avatar")
                    .padding(.trailing, 8)
            }
            VStack(alignment: .leading, spacing: 4) {
                // メッセージのテキストを表示
                Text(message.content ?? "")
                    .font(.system(size: 14)) // フォントサイズを調整
                    .foregroundColor(message.role == .user ? .white : .black)
                    .padding(10)
                // ユーザーとAIのメッセージで背景色を変更
                    .background(message.role == .user ? Color(#colorLiteral(red: 0.2078431373, green: 0.7647058824, blue: 0.3450980392, alpha: 1)) : Color(#colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9176470588, alpha: 1)))
                    .cornerRadius(20) // 角を丸くする
            }
            .padding(.vertical, 5)
            // ユーザー以外のメッセージの場合は右側にスペースを追加
            if message.role != .user {
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
