//
//  TestView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/10.
//

import SwiftUI

struct TestView: View {
    @State private var text: String = ""
    var body: some View {
        NavigationStack{
            VStack {
                TextEditor(text: $text)
                    .background(.red)
                    .padding(.top, 10)
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("テスト")
                            .font(.headline)
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)) // ツールバーの高さを調整するためのパディング
                    }
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            .background(Color.green)
        }
    }
}


#Preview {
    TestView()
}
