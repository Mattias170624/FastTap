//
//  DataController.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-15.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DataModel")
    
    init() {
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("!CoreData failed: \(error.localizedDescription)")
            }
        }
    }
}
