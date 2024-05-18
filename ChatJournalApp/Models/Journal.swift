//
//  Journal.swift
//  ChatJournalOpenAI
//
//  Created by Takumi Yokawa on 2024/05/14.
//

import Foundation
import SwiftData

@Model
final class Journal: Identifiable {
    var id = UUID().uuidString
    var date: Date = Date()
    var text: String = ""
    
    init(date: Date, text: String) {
        self.date = date
        self.text = text
    }
}

extension Date {
    func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月"
        return formatter.string(from: self)
    }
}

