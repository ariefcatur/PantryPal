//
//  EmptyStateView.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

import Foundation
import SwiftUI

struct EmptyStateView: View {
    var title: String = "Tak ada item"
    var message: String = "Tambah bahan makanan agar kamu dapat pengingat sebelum kedaluwarsa."
    var buttonTitle: String = "Tambah Item"
    var action: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "shippingbox.circle.fill")
        } description: {
            Text(message)
        } actions: {
            Button {
                action()
            } label: {
                Label(buttonTitle, systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview("Empty State – Light") {
    EmptyStateView { }
        .preferredColorScheme(.light)
}
#Preview("Empty State – Dark") {
    EmptyStateView { }
        .preferredColorScheme(.dark)
}
