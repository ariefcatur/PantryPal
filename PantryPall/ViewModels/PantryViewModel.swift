//
//  PantryViewModel.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

import SwiftData
import UserNotifications

/// View model for managing pantry items and their lifecycle
///
/// `PantryViewModel` handles CRUD operations for pantry items and integrates
/// with the notification service to schedule and cancel expiry reminders.
/// All operations are performed on the main actor for UI safety.
///
/// ## Example Usage
/// ```swift
/// let viewModel = PantryViewModel()
/// let item = PantryItem(name: "Milk", category: "Dairy", expiryDate: Date())
/// viewModel.add(context, item: item)
/// ```
@MainActor
final class PantryViewModel: ObservableObject {
    
    /// Adds a new pantry item to the data store
    ///
    /// This method inserts the item into the SwiftData context, saves it,
    /// and schedules expiry reminder notifications (3 days and 1 day before expiration).
    ///
    /// - Parameters:
    ///   - context: The SwiftData model context
    ///   - item: The pantry item to add
    func add(_ context: ModelContext, item: PantryItem) {
        context.insert(item)
        try? context.save()
        Task { await NotificationService.scheduleExpiryReminders(for: item) }
    }

    /// Deletes multiple pantry items from the data store
    ///
    /// This method removes the items from the SwiftData context, saves the changes,
    /// and cancels any associated notification reminders.
    ///
    /// - Parameters:
    ///   - context: The SwiftData model context
    ///   - items: Array of pantry items to delete
    func delete(_ context: ModelContext, items: [PantryItem]) {
        for it in items { context.delete(it) }
        try? context.save()
        Task { await NotificationService.cancelReminders(for: items) }
    }
}
