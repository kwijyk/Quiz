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

    // MARK: - Private
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Quiz")
        
        let fileManager = FileManager.default
        let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let destSqliteURL = applicationSupportURL.appendingPathComponent("Quiz.sqlite")
    
        if let sourceSqliteURL = Bundle.main.url(forResource: "Quiz", withExtension: "sqlite"),
            !FileManager.default.fileExists(atPath: destSqliteURL.path) {
            
            do {
                try FileManager.default.copyItem(at: sourceSqliteURL, to: destSqliteURL)
            } catch {
                print("Error with copy Database file")
            }
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    
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
            let sortByName = NSSortDescriptor(key: #keyPath(CategoryMO.name), ascending: true)
            request.sortDescriptors = [sortByName]
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
    
    func isQuestionsExist(for category: Category) -> Bool {
        guard let category = fetchCategory(byID: category.id, in: persistentContainer.viewContext),
              let questions = category.question else { return false }
        return questions.count > 0
    }
    
    func fetchQuestions(for category: Category, complitionHandler: ([Question]) -> Void) {
        guard let fetchedCategory = fetchCategory(byID: category.id, in: persistentContainer.viewContext),
              let questions = fetchedCategory.question as? Set<QuestionMO> else {
                complitionHandler([])
                return
        }
        let rusult = questions.map { $0.convertedPlainObject() }
        complitionHandler(rusult)
    }
    
    func saveQuestions(_ questions: [Question], for category: Category) {
        persistentContainer.performBackgroundTask { [unowned self] bgContext in
            guard let fetchedCategory = self.fetchCategory(byID: category.id, in: bgContext) else { return }
            questions.forEach({ question in
                let questionMO = QuestionMO(context: bgContext)
                questionMO.setup(from: question)
                questionMO.category = fetchedCategory
                fetchedCategory.addToQuestion(questionMO)
                
                question.options.enumerated().forEach { (index, option) in
                    let optionMO = OptionMO(context: bgContext)
                    optionMO.index = Int32(index)
                    optionMO.optionOfAnswer = option
                    optionMO.question = questionMO
                    questionMO.addToOptions(optionMO)
                }
            })
            try? bgContext.save()
        }
    }
    
    func deleteAllData() {
//        persistentContainer.performBackgroundTask { bgContext in
//            let fetchedCategory: [CategoryMO]? = try? bgContext.fetch(CategoryMO.fetchRequest())
//            fetchedCategory?.forEach { bgContext.delete($0) }
//            try? bgContext.save()
//        }
        let request = NSBatchDeleteRequest(fetchRequest: CategoryMO.fetchRequest())
        let _ = try? persistentContainer.viewContext.execute(request)
    }
    
    // MARK: - Private
    private func fetchCategory(byID categoryID: Int, in context: NSManagedObjectContext) -> CategoryMO?  {
        let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(CategoryMO.id)) == \(categoryID)")
        let categorys = try? context.fetch(request)
        return categorys?.first
    }
}
