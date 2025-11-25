//
//  PantryListView.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

import SwiftUI
import SwiftData

/// A list view displaying all pantry items with search and filtering capabilities
struct PantryListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \PantryItem.expiryDate) private var items: [PantryItem]
    @State private var showAdd = false
    @State private var editingItem: PantryItem?
    @State private var search = ""

    /// Filtered items based on search query
    private var filtered: [PantryItem] {
        let s = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return s.isEmpty ? items : items.filter { 
            $0.name.lowercased().contains(s) || $0.category.lowercased().contains(s) 
        }
    }
    
    /// Items expiring soon (within 3 days) or already expired
    private var expiringItems: [PantryItem] {
        filtered.filter { $0.isNearExpiry || $0.isExpired }
    }
    
    /// Items that are still fresh (more than 3 days)
    private var freshItems: [PantryItem] {
        filtered.filter { !$0.isNearExpiry && !$0.isExpired }
    }

    var body: some View {
        NavigationStack {
            Group {
                if filtered.isEmpty {
                    EmptyStateView(action: { showAdd = true })
                } else {
                    List {
                        if !expiringItems.isEmpty {
                            Section {
                                ForEach(expiringItems) { item in 
                                    Row(item)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button(role: .destructive) {
                                                deleteItem(item)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            Button {
                                                editingItem = item
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(.blue)
                                        }
                                }
                            } header: {
                                Label("Expiring Soon (≤ 3 days)", systemImage: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                            }
                        }
                        
                        if !freshItems.isEmpty {
                            Section {
                                ForEach(freshItems) { item in 
                                    Row(item)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button(role: .destructive) {
                                                deleteItem(item)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            Button {
                                                editingItem = item
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(.blue)
                                        }
                                }
                            } header: {
                                Label("Fresh Items", systemImage: "checkmark.seal.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    .animation(.easeInOut, value: filtered.count)
                }
            }
            .navigationTitle("PantryPal")
            .searchable(text: $search, prompt: "Search by name or category...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { 
                        showAdd = true
                        hapticFeedback(.light)
                    } label: { 
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddEditItemView { item in
                    let vm = PantryViewModel()
                    vm.add(context, item: item)
                    hapticFeedback(.medium)
                }
                .presentationDetents([.medium, .large])
            }
            .sheet(item: $editingItem) { item in
                AddEditItemView(existingItem: item) { updatedItem in
                    item.name = updatedItem.name
                    item.category = updatedItem.category
                    item.quantity = updatedItem.quantity
                    item.location = updatedItem.location
                    item.expiryDate = updatedItem.expiryDate
                    item.updatedAt = .now
                    try? context.save()
                    hapticFeedback(.medium)
                }
                .presentationDetents([.medium, .large])
            }
            .task { await NotificationService.requestPermission() }
        }
    }

    /// Row view for individual pantry item
    @ViewBuilder
    private func Row(_ item: PantryItem) -> some View {
        HStack(spacing: 12) {
            // Category icon
            categoryIcon(for: item)
            
            itemDetails(for: item)
            
            Spacer()
            
            // Status badge
            statusBadge(for: item)
        }
        .padding(.vertical, 4)
        .accessibilityLabel("\(item.name), \(item.daysLeft) days left")
        .accessibilityHint("Swipe to edit or delete")
    }
    
    @ViewBuilder
    private func categoryIcon(for item: PantryItem) -> some View {
        ZStack {
            Circle()
                .fill(categoryColor(item.category).opacity(0.15))
                .frame(width: 40, height: 40)
            Text(categoryEmoji(item.category))
                .font(.title3)
        }
    }
    
    @ViewBuilder
    private func itemDetails(for item: PantryItem) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .font(.headline)
            
            itemMetadata(for: item)
        }
    }
    
    @ViewBuilder
    private func itemMetadata(for item: PantryItem) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "tag.fill")
                .font(.caption2)
            Text(item.category)
            Text("•")
            Image(systemName: "location.fill")
                .font(.caption2)
            Text(item.location)
            Text("•")
            Image(systemName: "number")
                .font(.caption2)
            Text("\(item.quantity)")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private func statusBadge(for item: PantryItem) -> some View {
        let statusCol = statusColor(for: item.daysLeft)
        VStack(alignment: .trailing, spacing: 4) {
            Text(statusText(for: item.daysLeft))
                .font(.caption2.weight(.semibold))
                .foregroundStyle(statusCol)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(statusCol.opacity(0.15), in: Capsule())
            Text(formattedDate(item.expiryDate))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Delete an item and cancel its notifications
    private func deleteItem(_ item: PantryItem) {
        context.delete(item)
        try? context.save()
        Task { await NotificationService.cancelReminders(for: [item]) }
        hapticFeedback(.medium)
    }
    
    /// Get status text based on days remaining
    private func statusText(for days: Int) -> String {
        if days < 0 { return "Expired" }
        if days == 0 { return "Today" }
        if days == 1 { return "Tomorrow" }
        return "\(days)d left"
    }
    
    /// Get status color based on days remaining
    private func statusColor(for days: Int) -> Color {
        if days < 0 { return .red }
        if days <= 3 { return .orange }
        if days <= 7 { return .yellow }
        return .green
    }
    
    /// Format date for display
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    /// Get category color
    private func categoryColor(_ category: String) -> Color {
        switch category.lowercased() {
        case "dairy": return .blue
        case "meat": return .red
        case "vegetables": return .green
        case "bakery": return .orange
        case "medicine": return .purple
        case "cosmetics": return .pink
        default: return .gray
        }
    }
    
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
    
    /// Trigger haptic feedback
    private func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

#Preview("With Items") {
    PantryListView()
        .modelContainer(previewContainer)
}

#Preview("Empty State") {
    PantryListView()
        .modelContainer(for: PantryItem.self, inMemory: true)
}
