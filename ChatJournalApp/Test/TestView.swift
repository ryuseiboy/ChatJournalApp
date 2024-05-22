//
//  TestView.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/10.
//

import SwiftUI


struct TestView: View {
    let cards = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"]
    var body: some View {
        ScrollView{
            ForEach(0..<cards.count/3) { row in // create number of rows
                HStack {
                    ForEach(0..<3) { column in // create 3 columns
                        Text(self.cards[row * 3 + column])
                    }
                }
            }
        }
    }

}

#Preview {
    TestView()
}
