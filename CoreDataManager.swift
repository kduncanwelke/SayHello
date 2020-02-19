//
//  CoreDataManager.swift
//  SayHello
//
//  Created by Kate Duncan-Welke on 2/19/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    lazy var managedObjectContext: NSManagedObjectContext = { [unowned self] in
        var container = self.persistentContainer
        return container.viewContext
        }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        var container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores() { storeDescription, error in
            if var error = error as NSError? {
                fatalError("unresolved error \(error), \(error.userInfo)")
            }
            
            storeDescription.shouldInferMappingModelAutomatically = true
            storeDescription.shouldMigrateStoreAutomatically = true
        }
        
        return container
    }()
}
