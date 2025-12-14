//
//  AssignmentImageListingApp.swift
//  AssignmentImageListing
//
//  Created by Abhay Chaurasia on 14/12/25.
//

import SwiftUI

@main
struct AssignmentImageListingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
