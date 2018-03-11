//
//  MainMenuViewController.swift
//  Quiz
//
//  Created by Sergey Gaponov on 3/11/18.
//  Copyright © 2018 Sergio. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
    }
    
    @IBAction func newGameAction(_ sender: Any) {
        let playModeVC = PlayModeViewController()
        navigationController?.pushViewController(playModeVC, animated: true)
    }
    
    @IBAction func leaderboardAction(_ sender: Any) {
    }
}
