//
//  QuestionStorage.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/19/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import Foundation

struct QuestionStorage {
        
    static func loadDataQuestion(by questionID: String) -> Question? {
        guard let questionData = UserDefaults.standard.object(forKey: questionID) as? [String : Any] else { return nil }
        
        guard let categoryID = questionData["categoryID"] as? Int else { return nil }
        guard let questionID = questionData["questionID"] as? Int else { return nil }
        guard let question = questionData["question"] as? String else { return nil }
        guard let options = questionData["options"] as? [String] else { return nil }
        guard let answer = questionData["answer"] as? Int else { return nil }
        guard let page = questionData["page"] as? Int else { return nil }
        
        let questionObj = Question(categoryID: categoryID, questionID: questionID, page: page, question: question, options: options, answer: answer)
        
        return questionObj
    }
    
    static func saveDataQuestion(_ question: Question) -> String {
        let dataDictionary: [String: Any] = ["categoryID" : question.categoryID,
                                             "questionID" : question.questionID,
                                             "question" : question.question,
                                             "options" : question.options,
                                             "answer" : question.answer]
        
        let stringQuestionKey = String(question.questionID)
        UserDefaults.standard.set(dataDictionary, forKey: stringQuestionKey)

        return stringQuestionKey
    }
    
    static func loadArrayDataQuestions(by questionsID: [String]) -> [Question] {
        var questions: [Question] = []
        for idKey in questionsID {
            guard let quest = QuestionStorage.loadDataQuestion(by: idKey) else { continue }
            questions.append(quest)
        }
        return questions
    }
    
    static func saveArrayDataQuestions(_ questions: [Question]) -> [String] {
        var questionsID: [String] = []
        for quest in questions {
            let questID = saveDataQuestion(quest)
            questionsID.append(questID)
        }
        return questionsID
    }
}
