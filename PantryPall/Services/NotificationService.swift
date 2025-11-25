//
//  NotificationService.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

import UserNotifications

/// Service for managing local notifications related to pantry item expiration
///
/// `NotificationService` handles requesting notification permissions,
/// scheduling expiry reminders, and canceling notifications when items are deleted.
/// Notifications are scheduled for 3 days and 1 day before expiration at 9:00 AM local time.
///
/// ## Example Usage
/// ```swift
/// // Request permission
/// await NotificationService.requestPermission()
///
/// // Schedule reminders for an item
/// let item = PantryItem(name: "Milk", category: "Dairy", expiryDate: Date())
/// await NotificationService.scheduleExpiryReminders(for: item)
///
/// // Cancel reminders when deleting items
/// await NotificationService.cancelReminders(for: [item])
/// ```
enum NotificationService {
    
    /// Requests user permission for local notifications
    ///
    /// This should be called once when the app launches or when the user
    /// first attempts to add an item. Requests authorization for alerts,
    /// badges, and sounds.
    ///
    /// - Returns: Authorization status (granted or denied)
    @discardableResult
    static func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print("Failed to request notification permission: \(error.localizedDescription)")
            return false
        }
    }

    /// Schedules expiry reminder notifications for a pantry item
    ///
    /// Creates two notifications:
    /// - One scheduled 3 days before expiration
    /// - One scheduled 1 day before expiration
    ///
    /// Both notifications are set to trigger at 9:00 AM local time.
    /// If the trigger date has already passed, the notification is skipped.
    ///
    /// - Parameter item: The pantry item to schedule reminders for
    static func scheduleExpiryReminders(for item: PantryItem) async {
        let center = UNUserNotificationCenter.current()
        
        for days in [3, 1] {
            // Calculate trigger date (days before expiration)
            guard let triggerDate = Calendar.current.date(byAdding: .day, value: -days, to: item.expiryDate),
                  triggerDate > .now else { continue }

            // Create notification content
            let content = UNMutableNotificationContent()
            content.title = "Item Expiring Soon: \(item.name)"
            content.body = "\(days) day(s) remaining. Location: \(item.location)"
            content.sound = .default
            content.categoryIdentifier = "EXPIRY_REMINDER"
            
            // Add metadata for potential future actions
            content.userInfo = [
                "itemId": item.id.uuidString,
                "itemName": item.name,
                "daysLeft": days
            ]

            // Set trigger for 9:00 AM on the reminder date
            var date = Calendar.current.dateComponents([.year, .month, .day], from: triggerDate)
            date.hour = 9
            date.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            let id = "\(item.id.uuidString)-\(days)"
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            do {
                try await center.add(request)
            } catch {
                print("Failed to schedule notification for \(item.name): \(error.localizedDescription)")
            }
        }
    }

    /// Cancels all pending reminder notifications for the specified items
    ///
    /// This should be called when items are deleted or when their expiry
    /// date is updated. Removes both the 3-day and 1-day reminders.
    ///
    /// - Parameter items: Array of pantry items whose reminders should be canceled
    static func cancelReminders(for items: [PantryItem]) async {
        let ids = items.flatMap { item in
            ["\(item.id.uuidString)-3", "\(item.id.uuidString)-1"]
        }
        
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ids)
    }
}
