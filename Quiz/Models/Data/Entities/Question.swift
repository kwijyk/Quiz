//
//  Question.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/14/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Question {
//let category: Category
    let categoryID: Int
    let questionID: Int
    let page: Int
    let question: String
    let options: [String]
    
    let answer: Int
}

extension Question {
    
    init?(json: JSON, page: Int) {
        guard let categoryID = json["category", "id"].int,
              let questionID = json["id"].int,
              let question = json["question"].string else { return nil }
        
        self.categoryID = categoryID
        self.questionID = questionID
        self.question = question
        self.answer = json["answers"].intValue - 1
        
        var currentAnswers: [String] = []
        var optionIndex = 1
        while let optionOfAnswer = json["option\(optionIndex)"].string {
            currentAnswers.append(optionOfAnswer)
            optionIndex += 1
        }
        self.options = currentAnswers
        self.page = page
    }
}


