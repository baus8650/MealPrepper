//
//  CloudSharingController.swift
//  MealPlanner
//
//  Created by Tim Bausch on 3/13/23.
//

import CloudKit
import SwiftUI

struct CloudSharingView: UIViewControllerRepresentable {
    let share: CKShare
    let container: CKContainer
    let household: Household
    
    func makeCoordinator() -> CloudSharingCoordinator {
        CloudSharingCoordinator(household: household)
    }
    
    func makeUIViewController(context: Context) -> UICloudSharingController {
        share[CKShare.SystemFieldKey.title] = household.name
        let controller = UICloudSharingController(share: share, container: container)
        controller.modalPresentationStyle = .formSheet
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UICloudSharingController, context: Context) {
    }
}

final class CloudSharingCoordinator: NSObject, UICloudSharingControllerDelegate {
    let stack = CoreDataStack.shared
    let household: Household
    init(household: Household) {
        self.household = household
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        household.name
    }
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("Failed to save share: \(error)")
    }
    
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("Saved the share")
    }
    
    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        if !stack.isOwner(object: household) {
            stack.delete(household)
        }
    }
}

