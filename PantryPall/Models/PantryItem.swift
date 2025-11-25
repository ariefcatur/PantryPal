//
//  PantryItem.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//


import SwiftData
import Foundation

/// A model representing a pantry item with expiration tracking
///
/// `PantryItem` stores information about food items or other perishable goods,
/// including their expiration date, location, and quantity. It provides computed
/// properties to determine expiration status and remaining days.
///
/// ## Example Usage
/// ```swift
/// let milk = PantryItem(
///     name: "Milk",
///     category: "Dairy",
///     quantity: 2,
///     location: "Fridge",
///     expiryDate: Date().addingTimeInterval(86400 * 5)
/// )
/// print(milk.daysLeft) // 5
/// print(milk.isNearExpiry) // true if <= 3 days
/// ```
@Model
final class PantryItem {
    /// Unique identifier for the pantry item
    @Attribute(.unique) var id: UUID
    
    /// Name of the item (e.g., "Milk", "Bread")
    var name: String
    
    /// Category classification (e.g., "Dairy", "Bakery", "Vegetables")
    var category: String
    
    /// Quantity of items
    var quantity: Int
    
    /// Storage location (e.g., "Fridge", "Pantry", "Freezer")
    var location: String
    
    /// Date when the item expires
    var expiryDate: Date
    
    /// Timestamp when the item was created
    var createdAt: Date
    
    /// Timestamp when the item was last updated
    var updatedAt: Date

    /// Initializes a new pantry item
    ///
    /// - Parameters:
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - name: Name of the item
    ///   - category: Category classification (defaults to "Other")
    ///   - quantity: Number of items (defaults to 1)
    ///   - location: Storage location (defaults to "Pantry")
    ///   - expiryDate: Date when the item expires
    init(
        id: UUID = UUID(),
        name: String,
        category: String = "Other",
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

    /// Number of days remaining until expiration
    ///
    /// Returns a negative number if the item has already expired.
    /// Calculated from the current date to the expiry date.
    var daysLeft: Int {
        Calendar.current.dateComponents([.day], from: .now, to: expiryDate).day ?? 0
    }
    
    /// Whether the item has expired (past expiration date)
    var isExpired: Bool { expiryDate < Date() }
    
    /// Whether the item is near expiration (3 days or less, but not expired)
    var isNearExpiry: Bool { daysLeft <= 3 && daysLeft >= 0 }
}
