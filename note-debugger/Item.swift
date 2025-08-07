//
//  Item.swift
//  note-debugger
//
//  Created by Jonathan Duran on 06/08/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
