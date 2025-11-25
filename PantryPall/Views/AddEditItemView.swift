//
//  AddEditItemView.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//


import SwiftUICore
import SwiftUI

/// View for adding new items or editing existing pantry items
struct AddEditItemView: View {
    var existingItem: PantryItem?
    var onSave: (PantryItem) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var qty = 1
    @State private var category = "Other"
    @State private var location = "Pantry"
    @State private var expiry = Calendar.current.date(byAdding: .day, value: 7, to: .now)!
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case name, category, location
    }
    
    private let predefinedCategories = ["Dairy", "Meat", "Vegetables", "Bakery", "Medicine", "Cosmetics", "Other"]
    private let predefinedLocations = ["Pantry", "Fridge", "Freezer", "Cabinet", "Counter"]
    
    private var isEditing: Bool {
        existingItem != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Item Name", text: $name)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .category }
                    
                    Stepper("Quantity: \(qty)", value: $qty, in: 1...999)
                } header: {
                    Label("Item Details", systemImage: "shippingbox")
                }
                
                Section {
                    Picker("Category", selection: $category) {
                        ForEach(predefinedCategories, id: \.self) { cat in
                            HStack {
                                Text(categoryEmoji(cat))
                                Text(cat)
                            }
                            .tag(cat)
                        }
                    }
                    
                    Picker("Location", selection: $location) {
                        ForEach(predefinedLocations, id: \.self) { loc in
                            HStack {
                                Text(locationEmoji(loc))
                                Text(loc)
                            }
                            .tag(loc)
                        }
                    }
                } header: {
                    Label("Classification", systemImage: "tag")
                }
                
                Section {
                    DatePicker("Expiry Date", selection: $expiry, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    
                    if expiry < Date() {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                            Text("This item will be marked as expired")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        let daysUntilExpiry = Calendar.current.dateComponents([.day], from: Date(), to: expiry).day ?? 0
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundStyle(daysUntilExpiry <= 3 ? .orange : .green)
                            Text("Expires in \(daysUntilExpiry) day(s)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Label("Expiration", systemImage: "calendar")
                }
            }
            .navigationTitle(isEditing ? "Edit Item" : "Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Update" : "Add") {
                        let item = PantryItem(
                            id: existingItem?.id ?? UUID(),
                            name: name,
                            category: category,
                            quantity: qty,
                            location: location,
                            expiryDate: expiry
                        )
                        onSave(item)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                if let item = existingItem {
                    name = item.name
                    qty = item.quantity
                    category = item.category
                    location = item.location
                    expiry = item.expiryDate
                } else {
                    focusedField = .name
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Get category emoji
    private func categoryEmoji(_ category: String) -> String {
        switch category.lowercased() {
        case "dairy": return "🥛"
        case "meat": return "🥩"
        case "vegetables": return "🥬"
        case "bakery": return "🍞"
        case "medicine": return "💊"
        case "cosmetics": return "💄"
        default: return "📦"
        }
    }
    
    /// Get location emoji
    private func locationEmoji(_ location: String) -> String {
        switch location.lowercased() {
        case "fridge": return "❄️"
        case "freezer": return "🧊"
        case "pantry": return "🗄️"
        case "cabinet": return "🚪"
        case "counter": return "🪑"
        default: return "📍"
        }
    }
}

#Preview("Add New Item") {
    AddEditItemView { _ in }
}

#Preview("Edit Existing Item") {
    AddEditItemView(existingItem: PantryItem(
        name: "Milk",
        category: "Dairy",
        quantity: 2,
        location: "Fridge",
        expiryDate: Date().addingTimeInterval(86400 * 3)
    )) { _ in }
}
