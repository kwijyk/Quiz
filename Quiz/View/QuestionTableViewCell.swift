//
//  CategoryCell.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/14/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    
    @IBOutlet private weak var ibLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = selected ? .darkGray : .black
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
