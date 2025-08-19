//
//  PantryListView.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

import SwiftUI
import SwiftData

struct PantryListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \PantryItem.expiryDate) private var items: [PantryItem]
    @State private var showAdd = false
    @State private var search = ""

    private var filtered: [PantryItem] {
        let s = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return s.isEmpty ? items : items.filter { $0.name.lowercased().contains(s) || $0.category.lowercased().contains(s) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if filtered.isEmpty {
                    EmptyStateView(action: { showAdd = true })
                } else {
                    List {
                        Section("Akan Expired ≤ 3 Hari") {
                            ForEach(filtered.filter { $0.isNearExpiry }) { item in Row(item) }
                        }
                        Section("Semua") {
                            ForEach(filtered) { item in Row(item) }
                                .onDelete { indexSet in
                                    let toDelete = indexSet.map { filtered[$0] }
                                    for it in toDelete { context.delete(it) }
                                    try? context.save()
                                }
                        }
                    }
                }
            }
            .navigationTitle("PantryPal")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    TextField("Cari nama/kategori…", text: $search)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 220)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAdd = true } label: { Image(systemName: "plus.circle.fill") }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddEditItemView { item in
                    let vm = PantryViewModel()
                    vm.add(context, item: item)
                }
                .presentationDetents([.medium])
            }
            .task { await NotificationService.requestPermission() }
        }
    }

    @ViewBuilder
    private func Row(_ item: PantryItem) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name).font(.headline)
                Text("\(item.category) • \(item.location)").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(item.isExpired ? "Expired" : "H\(item.daysLeft)")
                .font(.caption2).padding(6)
                .background(item.isExpired ? .red.opacity(0.15) : (item.isNearExpiry ? .orange.opacity(0.15) : .green.opacity(0.15)))
                .clipShape(.capsule)
        }
        .accessibilityLabel("\(item.name), sisa \(item.daysLeft) hari")
    }
}
