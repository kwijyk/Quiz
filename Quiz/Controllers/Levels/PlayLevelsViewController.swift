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
                return "MIDDLE"
            case .thirdLevel:
                return "HARD"
            }
        }
        
        var timeButtonName: String {
            switch self {
            case .firstLevel:
                return "1 MINUTE"
            case .secondLevel:
                return "2 MINUTE"
            case .thirdLevel:
                return "3 MINUTE"
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

    @IBAction private func levelDidSelected(_ sender: UIButton) {
        switch playType {
        case .forLife:
            let questionVC = QuestionViewController()
            navigationController?.pushViewController(questionVC, animated: true)
        case .forTime:
            CoreDataManager.instance.fetchRandomQuestions(quantity: 1, complitionHandler: { [weak self] questions in
                guard let unQuestion = questions.first else { return }
                let answerVC = AnswerViewController(question: unQuestion)
                self?.navigationController?.pushViewController(answerVC, animated: true)
            })
        }
    }
}
