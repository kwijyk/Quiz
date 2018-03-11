//
//  LevelsViewController.swift
//  Quiz
//
//  Created by Sergey Gaponov on 3/11/18.
//  Copyright © 2018 Sergio. All rights reserved.
//

import UIKit

class PlayLevelsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Level"
    }

    @IBAction func firstLevelDidSelected(_ sender: UIButton) {
        let questionVC = QuestionViewController()
        navigationController?.pushViewController(questionVC, animated: true)
    }
    
    @IBAction func secondLevelDidSelected(_ sender: UIButton) {
    }
    
    @IBAction func thirdLevelDidSelected(_ sender: UIButton) {
    }
}
