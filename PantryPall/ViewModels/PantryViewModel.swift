//
//  PantryViewModel.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

import SwiftData
import UserNotifications

@MainActor
final class PantryViewModel: ObservableObject {
    func add(_ context: ModelContext, item: PantryItem) {
        context.insert(item)
        try? context.save()
        Task { await NotificationService.scheduleExpiryReminders(for: item) }
    }

    func delete(_ context: ModelContext, items: [PantryItem]) {
        for it in items { context.delete(it) }
        try? context.save()
        Task { await NotificationService.cancelReminders(for: items) }
    }
}
