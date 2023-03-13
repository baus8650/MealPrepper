//
//  MealPlannerApp.swift
//  MealPlanner
//
//  Created by Tim Bausch on 3/13/23.
//

import SwiftUI

@main
struct MealPlannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            HouseholdListView()
                .environment(\.managedObjectContext, CoreDataStack.shared.context)
        }
    }
}
