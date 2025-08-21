//
//  PantryDashboardView.swift
//  PantryPall
//
//  Created by Arief Catur on 21/08/25.
//
import SwiftUI
import SwiftData

// MARK: - Dashboard (Header, Stats, Grid)
struct PantryDashboardView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \PantryItem.expiryDate) private var items: [PantryItem]

    // In-app theme toggle (override system)
    @AppStorage("useDarkMode") private var useDarkMode = false
    @State private var showAdd = false

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    // Grid like Tailwind (1/2/3 cols adaptif)
    private let cardCols = [GridItem(.adaptive(minimum: 260), spacing: 16, alignment: .top)]

    // MARK: Stats
    private var expiredCount: Int { items.filter { $0.daysLeft < 0 }.count }
    private var soonCount: Int { items.filter { (0...3).contains($0.daysLeft) }.count }
    private var freshCount: Int { items.filter { $0.daysLeft > 7 }.count }

    // Sort sama seperti React: paling cepat kedaluwarsa dulu
    private var sortedItems: [PantryItem] {
        items.sorted { a, b in a.daysLeft < b.daysLeft }
    }

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 48, height: 48)
                                Text("⏰").font(.title2)
                            }
                            Text("Expiry Tracker")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.primary)
                        }

                        Spacer()

                        HStack(spacing: 12) {
                            Button {
                                showAdd = true
                            } label: {
                                Label("Add Item", systemImage: "plus.circle.fill")
                                    .font(.headline)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 14)
                                    .background(LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .trailing))
                                    .foregroundStyle(.white)
                                    .clipShape(Capsule())
                                    .shadow(radius: 6, y: 2)
                            }

                            Button {
                                useDarkMode.toggle()
                            } label: {
                                Image(systemName: useDarkMode ? "sun.max.fill" : "moon.fill")
                                    .font(.title3)
                                    .padding(10)
                                    .background(.thinMaterial, in: Circle())
                            }
                            .accessibilityLabel("Toggle Dark Mode")
                        }
                    }
                    .padding(.horizontal)

                    // Stats Cards
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 12)], spacing: 12) {
                        StatCard(title: "Total Items", value: "\(items.count)", symbol: "shippingbox", tint: .blue)
                        StatCard(title: "Expired", value: "\(expiredCount)", symbol: "xmark.octagon.fill", tint: .red)
                        StatCard(title: "Expiring Soon", value: "\(soonCount)", symbol: "exclamationmark.triangle.fill", tint: .orange)
                        StatCard(title: "Fresh", value: "\(freshCount)", symbol: "checkmark.seal.fill", tint: .green)
                    }
                    .padding(.horizontal)

                    // Items Grid
                    if sortedItems.isEmpty {
                        VStack(spacing: 8) {
                            Text("📦").font(.system(size: 48))
                            Text("No items yet").font(.title3).bold()
                            Text("Add your first item to start tracking expiry dates!")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 48)
                    } else {
                        LazyVGrid(columns: cardCols, spacing: 16) {
                            ForEach(sortedItems) { item in
                                ItemCard(
                                    item: item,
                                    color: accentColor(for: item),
                                    dateText: dateFormatter.string(from: item.expiryDate),
                                    statusText: statusText(for: item.daysLeft),
                                    statusColor: statusColor(for: item.daysLeft),
                                    onDelete: { delete(item) }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
                .padding(.top, 16)
            }
        }
        // Sheet Add Item (pakai view yang sudah ada)
        .sheet(isPresented: $showAdd) {
            AddEditItemView { item in
                // langsung insert + jadwalkan reminder seperti sebelumnya
                let vm = PantryViewModel()
                vm.add(context, item: item)
            }
            .presentationDetents([.medium, .large])
        }
        .preferredColorScheme(useDarkMode ? .dark : .light) // override seperti React toggle
    }

    // MARK: Helpers
    private var backgroundGradient: LinearGradient {
        if useDarkMode {
            return LinearGradient(
                colors: [Color(.sRGB, red: 20/255, green: 20/255, blue: 30/255, opacity: 1),
                         .purple.opacity(0.4),
                         .blue.opacity(0.35)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [.purple.opacity(0.12), .pink.opacity(0.08), .blue.opacity(0.12)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }

    // Warna aksen kartu atas berdasarkan kategori (fallback: hash UUID)
    private func accentColor(for item: PantryItem) -> Color {
        let key = item.category.lowercased()
        if let mapped = categoryMap[key] { return mapped }
        let palette: [Color] = [.red, .blue, .green, .purple, .pink, .orange, .teal]
        let seed = item.id.uuidString.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return palette[seed % palette.count]
    }

    private let categoryMap: [String: Color] = [
        "food": .pink, "dairy": .blue, "bakery": .orange, "meat": .red,
        "vegetables": .green, "medicine": .teal, "cosmetics": .purple
    ]

    private func statusText(for days: Int) -> String {
        if days < 0 { return "Expired \(abs(days)) days ago" }
        if days == 0 { return "Expires today!" }
        if days == 1 { return "Expires tomorrow" }
        return "\(days) days left"
    }

    private func statusColor(for days: Int) -> Color {
        if days < 0 { return .red }
        if days <= 3 { return .orange }
        if days <= 7 { return .yellow }
        return .green
    }

    private func delete(_ item: PantryItem) {
        context.delete(item)
        try? context.save()
        Task { await NotificationService.cancelReminders(for: [item]) }
    }
}

// MARK: - Subviews

private struct StatCard: View {
    let title: String
    let value: String
    let symbol: String
    let tint: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 24, weight: .bold))
            }
            Spacer()
            ZStack {
                Circle().fill(tint.opacity(0.15))
                Image(systemName: symbol)
                    .font(.title3)
                    .foregroundStyle(tint)
            }
            .frame(width: 44, height: 44)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

private struct ItemCard: View {
    let item: PantryItem
    let color: Color
    let dateText: String
    let statusText: String
    let statusColor: Color
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(color)
                .frame(height: 6)

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(item.category)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.thinMaterial, in: Capsule())
                    }
                    Spacer()
                    Button(role: .destructive) { onDelete() } label: {
                        Image(systemName: "trash.fill").imageScale(.medium)
                            .foregroundStyle(.secondary)
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Delete \(item.name)")
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Expires: \(dateText)")
                        .foregroundStyle(.secondary)
                    Text(statusText)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(statusColor)
                }
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.regularMaterial)
        )
        .shadow(color: .black.opacity(0.06), radius: 10, y: 3)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.name), \(statusText)")
    }
}

// MARK: - Preview
#Preview {
PantryDashboardView()
.modelContainer(previewContainer)
.preferredColorScheme(.light)
.onAppear { UserDefaults.standard.set(false, forKey: "useDarkMode") }
}

