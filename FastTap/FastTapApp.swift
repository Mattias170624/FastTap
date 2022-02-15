//
//  FastTapApp.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-01-16.
//

import SwiftUI
import Firebase

@main
struct FastTapApp: App {
    
    @StateObject private var dataController = DataController()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Loginscreen()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
