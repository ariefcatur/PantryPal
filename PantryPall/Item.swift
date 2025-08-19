//
//  Item.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
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
