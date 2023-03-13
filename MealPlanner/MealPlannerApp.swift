//
//  MealPlannerApp.swift
//  MealPlanner
//
//  Created by Tim Bausch on 3/13/23.
//

import SwiftUI

@main
struct MealPlannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
