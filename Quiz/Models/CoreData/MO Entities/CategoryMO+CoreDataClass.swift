//
//  CategoryMO+CoreDataClass.swift
//  Quiz
//
//  Created by Sergio on 1/26/18.
//  Copyright © 2018 Sergio. All rights reserved.
//
//

import Foundation
import CoreData


public class CategoryMO: NSManagedObject {

    func convertedPlainObject() -> Category {
        return Category(id: Int(self.id), page: Int(self.page), name: self.name ?? "")
    }
    
    func setup(from category: Category) {
        self.id = Int32(category.id)
        self.name = category.name
        self.page = Int32(category.page)
    }
}
