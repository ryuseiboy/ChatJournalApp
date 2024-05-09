//
//  ChatMessage.swift
//  ChatJournalApp
//
//  Created by Takumi Yokawa on 2024/05/09.
//

import Foundation

public enum ChatRole {
    case system
    case user
}

public struct ChatMessage: Identifiable {
    public var id = UUID().uuidString
    public let role: ChatRole
    public let content: String?
    
    public init(role: ChatRole, content: String? = nil) {
        self.role = role
        self.content = content
    }
}
