//
//  CategoryCell.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/14/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    static let reuseIdentifier = String(describing: CategoryCell.self)
    static let nib = UINib(nibName: String(describing: CategoryCell.self), bundle: nil)
    
    @IBOutlet private weak var ibLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func updateCategoryCell(category: Category) {
        ibLabel.textAlignment = .center
        ibLabel.text = category.name
    }
    
    func updateQuestionCell(question: Question) {
        ibLabel.textAlignment = .natural
        ibLabel.text = question.question
    }
}
