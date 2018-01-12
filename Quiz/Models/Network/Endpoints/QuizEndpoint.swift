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
    case categories
    case questions(category: Category)
    
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
        }
    }

    var parameters: [String : Any]? {
        return nil
    }
}
