//
//  CoreDataStack.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/24.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataStack {
    static let instance = CoreDataStack()
    
    // Only allow static use, no instance creation
    private init() {}
    
    private lazy var persistentContainar: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Nukon")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let viewContext = persistentContainar.viewContext
        return viewContext
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        let context = persistentContainar.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }()
    
    func saveTo(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                preconditionFailure(error.localizedDescription)
            }
        }
    }
    
    func delete(object: NSManagedObject, from context: NSManagedObjectContext) {
        context.delete(object)
    }
}
