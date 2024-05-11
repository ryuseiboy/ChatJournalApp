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
    var journalText: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                Text(journalText)
            }
            .navigationBarItems(trailing: // ナビゲーションバーの左側にボタンを配置
                                Button("完了") { // ボタンに表示されるテキストとアクション
                // ボタンのアクション
                isPresentedB = false
                
                //dismiss()
            }
                .foregroundColor(.blue) // ボタンのテキスト色
            )
        }
    }
}

struct DiaryEntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryEntryDetailView(isPresentedB: .constant(true),journalText: "")
    }
}
