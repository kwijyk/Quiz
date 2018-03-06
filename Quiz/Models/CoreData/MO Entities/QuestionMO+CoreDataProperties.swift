//
//  QuestionMO+CoreDataProperties.swift
//  Quiz
//
//  Created by Sergio on 3/6/18.
//  Copyright © 2018 Sergio. All rights reserved.
//
//

import Foundation
import CoreData


extension QuestionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionMO> {
        return NSFetchRequest<QuestionMO>(entityName: "QuestionMO")
    }

    @NSManaged public var correctAnswerIndex: Int32
    @NSManaged public var page: Int32
    @NSManaged public var text: String?
    @NSManaged public var id: Int32
    @NSManaged public var category: CategoryMO?
    @NSManaged public var options: NSSet?

}

// MARK: Generated accessors for options
extension QuestionMO {

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: OptionMO)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: OptionMO)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSSet)

}
