//
//  QuestionMO+CoreDataClass.swift
//  Quiz
//
//  Created by Sergio on 1/26/18.
//  Copyright © 2018 Sergio. All rights reserved.
//
//

import Foundation
import CoreData


public class QuestionMO: NSManagedObject {

    func convertedPlainObject() -> Question {
        guard let categoryID = self.category?.id,
              let unwOptions = self.options as? Set<OptionMO> else {
            fatalError("Error")
        }
        let options = unwOptions.sorted { $0.index < $1.index }.flatMap { $0.optionOfAnswer }
        
        return Question(categoryID: Int(categoryID),
                        questionID: Int(self.id),
                        page: Int(self.page),
                        question: self.text!,
                        options: options,
                        answer: Int(self.correctAnswerIndex))
    }
    
    func setup(from question: Question) {
        self.id = Int32(question.questionID)
        self.category?.id = Int32(question.categoryID)
        self.page = Int32(question.page)
        self.text = question.question
        self.correctAnswerIndex = Int32(question.answer)
    }
}
