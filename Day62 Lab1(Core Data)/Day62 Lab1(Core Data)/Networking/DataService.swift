//
//  ViewController.swift
//  Day62 Lab1(Core Data)
//
//  Created by Fatimah Ayeidh on 18/05/1443 AH.
//

import Foundation
import CoreData


class DataService {
    
    static let shared = DataService()
    
    private let persistentContainer = NSPersistentContainer(name:"Day62_Lab1_Core_Data_")
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func load() {
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
