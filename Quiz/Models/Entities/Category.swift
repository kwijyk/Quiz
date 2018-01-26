//
//  Category.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/13/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Category {
    
    let id: Int
    let name: String
    let parentCategory: String
    let questionCount: Int
    let updateAt: String
}

extension Category {
    
    init?(json: JSON) {
        
        guard let id = json["id"].int,
              let name = json["name"].string else { return nil }
        
        self.id = id
        self.name = name
        self.parentCategory = json["parent_category"].stringValue
        self.questionCount = json["question_count"].intValue
        self.updateAt = json["updatedAt"].stringValue
    }
}
