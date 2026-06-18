//
//  SkylineApp.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 18/06/2026.
//

import SwiftUI

@main
struct SkylineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
