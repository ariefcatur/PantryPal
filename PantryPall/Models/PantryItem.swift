//
//  PantryItem.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

import SwiftData
import Foundation

@Model
final class PantryItem {
@Attribute(.unique) var id: UUID
var name: String
var category: String
var quantity: Int
var location: String
var expiryDate: Date
var createdAt: Date
var updatedAt: Date


init(
id: UUID = UUID(),
name: String,
category: String = "Lainnya",
quantity: Int = 1,
location: String = "Pantry",
expiryDate: Date
) {
self.id = id
self.name = name
self.category = category
self.quantity = quantity
self.location = location
self.expiryDate = expiryDate
self.createdAt = .now
self.updatedAt = .now
}


var daysLeft: Int {
Calendar.current.dateComponents([.day], from: .now, to: expiryDate).day ?? 0
}
var isExpired: Bool { expiryDate < Date() }
var isNearExpiry: Bool { daysLeft <= 3 && daysLeft >= 0 }
}
