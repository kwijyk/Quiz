//
//  QuizEndpoint.swift
//  Networking_hw19
//
//  Created by Sergio on 1/3/18.
//  Copyright © 2018 Sergey Intern . All rights reserved.
//

import Foundation
import Alamofire

enum QuizEndpoint: Endpoint {
    case categories(page: Int)
    case questions(category: Category)
    case randomQuestions
}

// MARK: - Endpoint
extension QuizEndpoint {
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        
        switch self {
        case .categories:
            return "categories"
        case .questions(let category):
            return "categories/\(category.id)/questions"
        case .randomQuestions:
            return "questions"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .categories(let page):
            return ["page": page, "limit": Constants.numberOfItemInPage]
        case .randomQuestions:
            return ["page": 3, "limit": 4]
        default:
            return nil
        }
    }
}
