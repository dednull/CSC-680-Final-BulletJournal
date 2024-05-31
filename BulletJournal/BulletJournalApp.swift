//
//  BulletJournalApp.swift
//  BulletJournal
//
//  Created by null on 5/30/24.
//

import SwiftUI

@main
struct BulletJournalApp: App {
    // Set up presistent container
    @StateObject private var jStack = JCoreManager.jStack

    var body: some Scene {
        WindowGroup {
            ContentView()
            // Add core data stack in enviroment
                .environment(\.managedObjectContext, jStack.presistContainer.viewContext)
        }
    }
}
