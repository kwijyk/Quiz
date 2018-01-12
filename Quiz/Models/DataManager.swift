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
    
    private var isDataDownloaded: Bool {
        set(newBoolValue) {
            UserDefaults.standard.set(newBoolValue, forKey: Constants.isDataDownloaded)
        }
        get {
            return UserDefaults.standard.bool(forKey: Constants.isDataDownloaded)
        }
    }
    
    private(set) var allQuestions: [Question]?
    
    func getCategory(complition: @escaping ([Category]) -> Void) {
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
                DispatchQueue.main.async {
                    complition(categoriesArray)
                }
            case.failure(let error):
                print(error)
            }
        }) 
    }
    
    func getQuestions(by category: Category) {
        let stringCategoryID = String(category.id)
        let keysQuestionID = UserDefaults.standard.object(forKey: stringCategoryID) as? [String] ?? [String]()
        var questionsArray = [Question]()
        
        if  keysQuestionID.isEmpty  {
//          https://qriusity.com/v1/categories/8/questions
            
            NetworkService.request(endpoint: QuizEndpoint.questions(category: category), completionHandler: { [weak self] result in
                switch result {
                case .success(let value):
                    let jsonObj = JSON(value)
                    guard let jsonArray = jsonObj.array else { return }
                    for objQuestion in jsonArray {
                        guard let question = Question(json: objQuestion) else { continue }
                        questionsArray.append(question)
                    }
                    self?.allQuestions = questionsArray
                    UserDefaults.standard.set(QuestionStorage.saveArrayDataQuestions(questionsArray), forKey: stringCategoryID)
                    self?.postMainQueueNotification(withName: .QestionsLoaded)
                case.failure(let error):
                    print(error)
                    self?.postMainQueueNotification(withName: .DidFailLoadQestions)
                }
            })
        } else {
           allQuestions = QuestionStorage.loadArrayDataQuestions(by: keysQuestionID)
            postMainQueueNotification(withName: .QestionsLoaded)
        }
    }
    
    private func postMainQueueNotification(withName name: Notification.Name, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
        }
    }
}
