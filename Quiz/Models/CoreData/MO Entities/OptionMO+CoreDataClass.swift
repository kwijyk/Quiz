//
//  OptionMO+CoreDataClass.swift
//  Quiz
//
//  Created by Sergey Gaponov on 2/25/18.
//  Copyright © 2018 Sergio. All rights reserved.
//
//

import Foundation
import CoreData


public class OptionMO: NSManagedObject {

    func convertedPlainObject() -> Option {
        return Option(index: Int(self.index), optionOfAnswer: self.optionOfAnswer ?? "")
    }
    
    func setup(from option: Option) {
        self.index = Int32(option.index)
        self.optionOfAnswer = option.optionOfAnswer
    }
}
