//
//  PantryPallApp.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

import SwiftUI
import SwiftData

@main
struct PantryPallApp: App {
    var body: some Scene {
            WindowGroup {
                PantryListView()
            }
            .modelContainer(for: PantryItem.self)
        }
    }
