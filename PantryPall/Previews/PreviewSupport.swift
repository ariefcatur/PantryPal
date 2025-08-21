//
//  PreviewSupport.swift
//  PantryPall
//
//  Created by Arief Catur on 21/08/25.
//
import SwiftUI
import SwiftData


#if DEBUG
extension Date {
func addingDays(_ days: Int) -> Date {
Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
}
}


@MainActor
let previewContainer: ModelContainer = {
let config = ModelConfiguration(isStoredInMemoryOnly: true)
let container = try! ModelContainer(for: PantryItem.self, configurations: config)


let sample: [PantryItem] = [
PantryItem(name: "Milk", category: "Dairy", quantity: 1, location: "Fridge", expiryDate: Date().addingDays(-2)),
PantryItem(name: "Bread", category: "Bakery", quantity: 1, location: "Pantry", expiryDate: Date().addingDays(1)),
PantryItem(name: "Yogurt", category: "Dairy", quantity: 2, location: "Fridge", expiryDate: Date().addingDays(7)),
PantryItem(name: "Spinach", category: "Vegetables", quantity: 1, location: "Fridge", expiryDate: Date().addingDays(10))
]
sample.forEach { container.mainContext.insert($0) }
return container
}()
#endif
