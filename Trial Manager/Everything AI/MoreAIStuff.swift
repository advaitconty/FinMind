//
//  MoreAIStuff.swift
//  Trial Manager
//
//  Created by Milind Contractor on 23/1/26.
//

import Foundation

enum ConversationalPerson: Codable {
    case person, ai
}

struct ConversationItem: Codable, Identifiable, Equatable {
    var id = UUID()
    var personResponding: ConversationalPerson
    var text: String
    var iconForPerson: String {
        switch self.personResponding {
        case .person:
            return "person"
        case .ai:
            return "apple.intelligence"
        }
    }
}
