//
//  Data.swift
//  notebook
//
//  Created by Павел Кошара on 21/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    private let modelName: String
    
    private(set) lazy var objectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }()
    
    private lazy var objectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Couldn't load data model \(modelName)")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        guard let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Couldn't get local storage directory")
        }
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: false
        ]

        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: persistentStoreURL,
                options: options)
        } catch {
            fatalError("Couldn't load persistent store")
        }
        
        return persistentStoreCoordinator
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
}
