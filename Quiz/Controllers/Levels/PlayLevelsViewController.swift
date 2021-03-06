//
//  LevelsViewController.swift
//  Quiz
//
//  Created by Sergey Gaponov on 3/11/18.
//  Copyright © 2018 Sergio. All rights reserved.
//

import UIKit

class PlayLevelsViewController: UIViewController {
    
    enum LevelType {
        case firstLevel
        case secondLevel
        case thirdLevel
        
        var lifeButtonName: String {
            switch self {
            case .firstLevel:
                return "EASY"
            case .secondLevel:
                return "NORMAL"
            case .thirdLevel:
                return "HARD"
            }
        }
        
        var timeButtonName: String {
            switch self {
            case .firstLevel:
                return "3 MINUTE"
            case .secondLevel:
                return "2 MINUTE"
            case .thirdLevel:
                return "1 MINUTE"
            }
        }
        
        var scoreCoefficient: Int {
            switch self {
            case .firstLevel:
                return 1
            case .secondLevel:
                return 2
            case .thirdLevel:
                return 3
            }
        }
        
        var livesQuantity: Int {
            switch self {
            case .firstLevel:
                return 4
            case .secondLevel:
                return 3
            case .thirdLevel:
                return 2
            }
        }
        
        var timerValue: Int {
            switch self {
            case .firstLevel:
                return 180
            case .secondLevel:
                return 120
            case .thirdLevel:
                return 60
            }
        }
        
        static let levelTypes: [LevelType] = [.firstLevel, .secondLevel, .thirdLevel]
    }
    
    @IBOutlet private var ibLevelButtons: [UIButton]!
    
    let playType: PlayModeViewController.GameModeType
    
    init(playType: PlayModeViewController.GameModeType) {
        self.playType = playType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Level"
        setupLevelButtons()
    }
    
    // MARK: - Private methods
    private func setupLevelButtons() {
        ibLevelButtons.enumerated().forEach({ index, button in
            let title: String
            switch playType {
            case .forLife:
                title = LevelType.levelTypes[index].lifeButtonName
            case .forTime:
                title = LevelType.levelTypes[index].timeButtonName
            }
            button.setTitle(title, for: .normal)
        })
    }
    
    private func getLevel(by button: UIButton) -> LevelType {
        guard let buttonIndex = ibLevelButtons.index(of: button) else {
            fatalError("There is no such type of level")
        }
        return LevelType.levelTypes[buttonIndex]
    }

    @IBAction private func levelDidSelected(_ sender: UIButton) {
        UserDefaults.standard.set(0, forKey: Constants.CurrentUserScoreKey)
        let levelType = getLevel(by: sender)
        switch playType {
        case .forLife:
            let questionVC = QuestionViewController(scoreCoefficient: levelType.scoreCoefficient, livesQuantity: levelType.livesQuantity)
            navigationController?.pushViewController(questionVC, animated: true)
        case .forTime:
            let answerVC = AnswerTimeViewController(time: levelType.timerValue, scoreCoefficient: levelType.scoreCoefficient)
            navigationController?.pushViewController(answerVC, animated: true)
        }
    }
}
