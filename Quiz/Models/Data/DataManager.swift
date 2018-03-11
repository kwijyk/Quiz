//
//  DataManager.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/13/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import PKHUD

final class DataManager {

    static let instance = DataManager()
    private init() {}
    
    private(set) var allQuestions: [Question]?
    
    func getCategory(page: Int, complition: @escaping ([Category]) -> Void) {
        NetworkService.request(endpoint: QuizEndpoint.categories(page: page), completionHandler: { result in
            switch result {
            case .success(let value):
                let jsonObj = JSON(value)
                guard let jsonArray = jsonObj.array else { return }
                var categoriesArray = [Category]()
                for objCategory in jsonArray {
                    guard let category = Category(json: objCategory, page: page) else { continue }
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
    
    func getQuestions(by category: Category, page: Int) {
        
        if CoreDataManager.instance.isQuestionsExist(for: category) {
            CoreDataManager.instance.fetchQuestions(for: category, complitionHandler: { [unowned self] questions in
                self.allQuestions = questions
                self.postMainQueueNotification(withName: .QestionsLoaded)
            })
        } else {
            var questionsArray = [Question]()
            NetworkService.request(endpoint: QuizEndpoint.questions(category: category, page: page), completionHandler: { [unowned self] result in
                switch result {
                case .success(let value):
                    let jsonObj = JSON(value)
                    guard let jsonArray = jsonObj.array else { return }
                    for objQuestion in jsonArray {
                        guard let question = Question(json: objQuestion, page: page) else { continue }
                        questionsArray.append(question)
                    }
                    self.allQuestions = questionsArray

                    if !questionsArray.isEmpty {
//                        CoreDataManager.instance.saveQuestions(questionsArray, for: category)
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            HUD.flash(.error, delay: 1.0)
                        }
                    }
                    self.postMainQueueNotification(withName: .QestionsLoaded)
                case.failure(let error):
                    print(error)
                    self.postMainQueueNotification(withName: .DidFailLoadQestions)
                }
            })
        }
    }
    
    func getRandomQuestions(page: Int, complition: @escaping ([Question]) -> Void) {
        NetworkService.request(endpoint: QuizEndpoint.randomQuestions, completionHandler: { result in
            switch result {
            case .success(let value):
                let jsonObj = JSON(value)
                guard let jsonArray = jsonObj.array else { return }
                var questionsArray = [Question]()
                for objQuestion in jsonArray {
                    guard let question = Question(json: objQuestion, page: page) else { continue }
                    questionsArray.append(question)
                }
                DispatchQueue.main.async {
                    complition(questionsArray)
                }
            case.failure(let error):
                print(error)
            }
        })
    }
    
    func clearLocalStorage() {
        CoreDataManager.instance.deleteAllData()
    }
    
    private func postMainQueueNotification(withName name: Notification.Name, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
        }
    }

}
