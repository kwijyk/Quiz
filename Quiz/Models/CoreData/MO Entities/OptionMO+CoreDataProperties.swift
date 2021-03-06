//
//  OptionMO+CoreDataProperties.swift
//  Quiz
//
//  Created by Sergio on 3/6/18.
//  Copyright © 2018 Sergio. All rights reserved.
//
//

import Foundation
import CoreData


extension OptionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OptionMO> {
        return NSFetchRequest<OptionMO>(entityName: "OptionMO")
    }

    @NSManaged public var index: Int32
    @NSManaged public var optionOfAnswer: String?
    @NSManaged public var question: QuestionMO?

}
