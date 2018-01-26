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
        guard let categoryID = self.category?.id else {
            fatalError("Error")
        }
        return Question(categoryID: Int(categoryID),
                        questionID: Int(self.id),
                        question: self.text!,
                        options: self.answers ?? [],
                        answer: Int(self.correctAnswerIndex) )
    }
    
    func setup(from question: Question) {
        self.id = Int32(question.questionID)
        self.category?.id = Int32(question.categoryID)
        self.text = question.question
        self.correctAnswerIndex = Int32(question.answer)
        self.answers = question.options
    }
}
