//
//  Note.swift
//  note-debugger
//
//  Created by Jonathan Duran on 06/08/2025.
//

import Foundation

struct Note: Identifiable, Codable {
    let id: String
    let created_at: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case created_at
        case title
    }
    
    init(id: String, created_at: String, title: String) {
        self.id = id
        self.created_at = created_at
        self.title = title
    }
    
    init(title: String) {
        self.id = ""
        self.created_at = ""
        self.title = title
    }
}

struct CreateNoteRequest: Codable {
    let title: String
}

struct UpdateNoteRequest: Codable {
    let title: String
}
