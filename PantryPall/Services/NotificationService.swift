//
//  NotificationService.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//


import UserNotifications

enum NotificationService {
    static func requestPermission() async {
        _ = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound])
    }

    static func scheduleExpiryReminders(for item: PantryItem) async {
        let center = UNUserNotificationCenter.current()
        // H-3 & H-1
        for days in [3, 1] {
            guard let triggerDate = Calendar.current.date(byAdding: .day, value: -days, to: item.expiryDate),
                  triggerDate > .now else { continue }
            let content = UNMutableNotificationContent()
            content.title = "Hampir kedaluwarsa: \(item.name)"
            content.body = "Sisa \(days) hari. Lokasi: \(item.location)."
            content.sound = .default

            var date = Calendar.current.dateComponents([.year,.month,.day], from: triggerDate)
            date.hour = 9 // jam 09.00 lokal
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            let req = UNNotificationRequest(identifier: "\(item.id.uuidString)-\(days)", content: content, trigger: trigger)
            try? await center.add(req)
        }
    }

    static func cancelReminders(for items: [PantryItem]) async {
        let ids = items.flatMap { ["\($0.id.uuidString)-3", "\($0.id.uuidString)-1"] }
        await UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}
