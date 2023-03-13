//
//  HouseholdListView.swift
//  MealPlanner
//
//  Created by Tim Bausch on 3/13/23.
//

import CloudKit
import SwiftUI

struct HouseholdListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)])
    var households: FetchedResults<Household>
    private let stack = CoreDataStack.shared
    @State var shouldShowAddHouseholdView: Bool = false
    @State private var share: CKShare?
    var body: some View {
        NavigationView {
            List {
                ForEach(households) { household in
                    NavigationLink {
                        HouseholdDetailView(household: household)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(household.name!)")
                                .font(.title2)
                            if let share = stack.getShare(household) {
                                if share.participants.count == 1 {
                                    Text("\(share.participants.count) Member")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("\(share.participants.count) Members")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            stack.delete(household)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Households")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        shouldShowAddHouseholdView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $shouldShowAddHouseholdView) {
                        AddHouseholdView()
                    }
                    
                }
            }
        }
    }
}

struct HouseholdView_Previews: PreviewProvider {
    static var previews: some View {
        HouseholdListView()
    }
}

