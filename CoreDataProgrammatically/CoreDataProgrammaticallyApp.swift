//
//  CoreDataProgrammaticallyApp.swift
//  CoreDataProgrammatically
//
//  Created by Mijo Gracanin on 17.11.2022..
//

import SwiftUI

@main
struct CoreDataProgrammaticallyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
