//
//  AddHouseholdView.swift
//  MealPlanner
//
//  Created by Tim Bausch on 3/13/23.
//

import SwiftUI

struct AddHouseholdView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    private let stack = CoreDataStack.shared
    @State var name: String = ""
    var body: some View {
        Form {
            TextField("Household name", text: $name)
            HStack(spacing: 48) {
                Spacer()
                Button {
                    saveHousehold()
                } label: {
                    Text("Save")
                }
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
                Spacer()
            }
        }
    }
    
    private func saveHousehold() {
        let newHousehold = Household(context: managedObjectContext)
        newHousehold.name = name
        stack.save()
    }
}

struct AddHouseholdView_Previews: PreviewProvider {
    static var previews: some View {
        AddHouseholdView()
    }
}

