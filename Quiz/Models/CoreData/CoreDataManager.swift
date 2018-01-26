//
//  CoreDataManager.swift
//  Quiz
//
//  Created by Sergio on 1/26/18.
//  Copyright © 2018 Sergio. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let instance = CoreDataManager()
    private init() { }
    
    // MARK: - Interface
    var isCategoriesExist: Bool {
        let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
        guard let categoriesCount = try? persistentContainer.viewContext.count(for: request) else {
            return false
        }
        return categoriesCount > 0
    }
    
    /// complitionHandler called in background qeue
    func fetchCategories(complitionHandler: @escaping ([Category]) -> Void) {
        persistentContainer.performBackgroundTask { bgContext in
            let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
            let fetchResult = (try? bgContext.fetch(request)) ?? []
            let result = fetchResult.map { $0.convertedPlainObject() }
            complitionHandler(result)
        }
    }
    
    func saveCategories(_ categories: [Category]) {
        persistentContainer.performBackgroundTask { bgContext in
            categories.forEach {
                let categoryMO = CategoryMO(context: bgContext)
                categoryMO.setup(from: $0)
            }
            try? bgContext.save()
        }
    }
    
    var isQuestionsExist : Bool {
        return false
    }
    
    func fetchQuestions(for categoryID: Int, complitionHandler: ([Question]) -> Void) {
        complitionHandler([])
    }
    
    func saveQuestions(_ questions: [Question], for categoryID: Int) {
        
    }
    
    func deleteAllData() {
        
    }
    
    // MARK: - Private
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Uscd")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    private func saveContext () {
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
