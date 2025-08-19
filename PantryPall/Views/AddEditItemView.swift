//
//  AddEditItemView.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

import SwiftUICore
import SwiftUI

struct AddEditItemView: View {
    var onSave: (PantryItem) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var qty = 1
    @State private var category = "Lainnya"
    @State private var location = "Pantry"
    @State private var expiry = Calendar.current.date(byAdding: .day, value: 7, to: .now)!

    var body: some View {
        NavigationStack {
            Form {
                Section("Item") {
                    TextField("Nama", text: $name)
                    Stepper("Jumlah: \(qty)", value: $qty, in: 1...999)
                    TextField("Kategori", text: $category)
                    TextField("Lokasi", text: $location)
                    DatePicker("Kedaluwarsa", selection: $expiry, displayedComponents: .date)
                }
            }
            .navigationTitle("Tambah Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Batal") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        onSave(PantryItem(name: name, category: category, quantity: qty, location: location, expiryDate: expiry))
                        dismiss()
                    }.disabled(name.isEmpty)
                }
            }
        }
    }
}
