//
//  DataManager.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/13/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import Foundation
import SwiftyJSON

final class DataManager {

    static let instance = DataManager()
    private init() {}
    
    private(set) var allQuestions: [Question]?
    
    func getCategory(complition: @escaping ([Category]) -> Void) {
        
        if CoreDataManager.instance.isCategoriesExist {
            CoreDataManager.instance.fetchCategories { fetchedCatecories in
                DispatchQueue.main.async {
                    complition(fetchedCatecories)
                }
            }
        } else {
            NetworkService.request(endpoint: QuizEndpoint.categories, completionHandler: { result in
                switch result {
                    
                case .success(let value):
                    let jsonObj = JSON(value)
                    guard let jsonArray = jsonObj.array else { return }
                    var categoriesArray = [Category]()
                    
                    for objCategory in jsonArray {
                        guard let category = Category(json: objCategory) else { continue }
                        categoriesArray.append(category)
                    }
                    CoreDataManager.instance.saveCategories(categoriesArray)
                    DispatchQueue.main.async {
                        complition(categoriesArray)
                    }
                case.failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func getQuestions(by category: Category) {
        
        if CoreDataManager.instance.isQuestionsExist(for: category) {
            CoreDataManager.instance.fetchQuestions(for: category, complitionHandler: { [unowned self] questions in
                self.allQuestions = questions
                self.postMainQueueNotification(withName: .QestionsLoaded)
            })
        } else {
            var questionsArray = [Question]()
            NetworkService.request(endpoint: QuizEndpoint.questions(category: category), completionHandler: { [unowned self] result in
                switch result {
                case .success(let value):
                    let jsonObj = JSON(value)
                    guard let jsonArray = jsonObj.array else { return }
                    for objQuestion in jsonArray {
                        guard let question = Question(json: objQuestion) else { continue }
                        questionsArray.append(question)
                    }
                    self.allQuestions = questionsArray

                    CoreDataManager.instance.saveQuestions(questionsArray, for: category)
                    self.postMainQueueNotification(withName: .QestionsLoaded)
                case.failure(let error):
                    print(error)
                    self.postMainQueueNotification(withName: .DidFailLoadQestions)
                }
            })
        }
    }
    
//    func clearLocalStorage() {
//        CoreDataManager.instance.deleteAllData()
//    }
    
    private func postMainQueueNotification(withName name: Notification.Name, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
        }
    }
}
