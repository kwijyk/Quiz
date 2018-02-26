//
//  CategoryMO+CoreDataProperties.swift
//  Quiz
//
//  Created by Sergey Gaponov on 2/25/18.
//  Copyright © 2018 Sergio. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryMO> {
        return NSFetchRequest<CategoryMO>(entityName: "CategoryMO")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var question: NSSet?
    
}

// MARK: Generated accessors for question
extension CategoryMO {

    @objc(addQuestionObject:)
    @NSManaged public func addToQuestion(_ value: QuestionMO)

    @objc(removeQuestionObject:)
    @NSManaged public func removeFromQuestion(_ value: QuestionMO)

    @objc(addQuestion:)
    @NSManaged public func addToQuestion(_ values: NSSet)

    @objc(removeQuestion:)
    @NSManaged public func removeFromQuestion(_ values: NSSet)

}
