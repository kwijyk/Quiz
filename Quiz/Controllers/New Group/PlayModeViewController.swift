//
//  PlayModeViewController.swift
//  Quiz
//
//  Created by Sergey Gaponov on 3/11/18.
//  Copyright © 2018 Sergio. All rights reserved.
//

import UIKit

class PlayModeViewController: UIViewController {

    enum GameModeType {
        case forLife
        case forTime
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Play"
    }

    @IBAction private func forLifePressed(_ sender: Any) {
        let playLevelsVC = PlayLevelsViewController(playType: .forLife)
        navigationController?.pushViewController(playLevelsVC, animated: true)
    }
    
    @IBAction private func forTimePressed(_ sender: Any) {
        let playLevelsVC = PlayLevelsViewController(playType: .forTime)
        navigationController?.pushViewController(playLevelsVC, animated: true)
    }
}
