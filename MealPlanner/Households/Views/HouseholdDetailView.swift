//
//  HouseholdDetailView.swift
//  MealPlanner
//
//  Created by Tim Bausch on 3/13/23.
//

import CloudKit
import SwiftUI

enum WeekDay: Int, CaseIterable {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
}

struct HouseholdDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var household: Household
    @State private var showShareSheet = false
    @State private var share: CKShare?
    
    @FetchRequest var meals: FetchedResults<Meal>
    
    private let stack = CoreDataStack.shared
    
    init(household: Household) {
        self.household = household
        var endOfDayDC = DateComponents()
        endOfDayDC.second = -1
        endOfDayDC.day = 1
        let beginningOfWeek = Calendar.current.startOfDay(for: Date().startOfWeek!)
        let endOfWeek = Calendar.current.date(byAdding: endOfDayDC, to: Date().endOfWeek!)
        
//        let datePredicate = NSPredicate(format: "date >= %@ && date <= %@", beginningOfWeek as CVarArg, endOfWeek! as CVarArg)
        let householdPredicate = NSPredicate(format: "household == %@", household)
        
//        let predicate = NSCompoundPredicate(type: .and, subpredicates: [datePredicate, householdPredicate])
        
        _meals = FetchRequest(
            entity: Meal.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Meal.date, ascending: true)
            ],
            predicate: householdPredicate
        )
        
    }
    var body: some View {
        VStack {
            List {
                
            }
        }
        .onAppear(perform: {
            self.share = stack.getShare(household)
        })
        .sheet(isPresented: $showShareSheet) {
            if let share = share {
                CloudSharingView(share: share, container: stack.ckContainer, household: household)
            }
        }
        .navigationTitle("\(household.name ?? "Default House")")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if !stack.isShared(object: household) {
                        Task {
                            await createShare(household)
                        }
                    }
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

extension HouseholdDetailView {
    private func string(for permission: CKShare.ParticipantPermission) -> String {
        switch permission {
        case .unknown:
            return "Unknown"
        case .none:
            return "None"
        case .readOnly:
            return "Read-Only"
        case .readWrite:
            return "Read-Write"
        @unknown default:
            fatalError("A new value added to CKShare.Participant.Permission")
        }
    }
    
    private func string(for role: CKShare.ParticipantRole) -> String {
        switch role {
        case .owner:
            return "Owner"
        case .privateUser:
            return "Private User"
        case .publicUser:
            return "Public User"
        case .unknown:
            return "Unknown"
        @unknown default:
            fatalError("A new value added to CKShare.Participant.Role")
        }
    }
    
    private func string(for acceptanceStatus: CKShare.ParticipantAcceptanceStatus) -> String {
        switch acceptanceStatus {
        case .accepted:
            return "Accepted"
        case .removed:
            return "Removed"
        case .pending:
            return "Invited"
        case .unknown:
            return "Unknown"
        @unknown default:
            fatalError("A new value added to CKShare.Participant.AcceptanceStatus")
        }
    }
    
    private func createShare(_ household: Household) async {
        do {
            let (_, share, _) = try await stack.persistentContainer.share([household], to: nil)
            share[CKShare.SystemFieldKey.title] = household.name
            self.share = share
        } catch {
            print("Failed to create share")
        }
    }
}
