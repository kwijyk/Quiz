//
//  AnswerViewController.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/18/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import UIKit
import PKHUD

class AnswerTimeViewController: UIViewController, Alertable {
    
    static let CurrentUserScoreKey = "CurrentUserScoreKey"
    static let MaxUserScoreKey = "MaxUserScoreKey"
    
    @IBOutlet private weak var ibRecordLabel: UILabel!
    @IBOutlet private weak var ibScoreLabel: UILabel!
    @IBOutlet private weak var ibAnswersContentView: UIStackView!
    @IBOutlet private weak var ibQuestionLabel: UILabel!
    @IBOutlet private weak var ibTimeCounterLabel: UILabel!

    private var record: Int {
        get { return UserDefaults.standard.integer(forKey: Constants.MaxTimeUserScoreKey) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.MaxTimeUserScoreKey) }
    }
    
    private var score: Int {
        get { return UserDefaults.standard.integer(forKey: Constants.CurrentUserScoreKey) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.CurrentUserScoreKey)
            ibScoreLabel.text = String(newValue) }
    }
    
    private let scoreCoefficient: Int
    private var question: Question?
    
    private var timeCounter: Int = 0 {
        didSet { ibTimeCounterLabel.text = String(timeCounter) }
    }
    private var timer: Timer?
    
    init(time: Int, scoreCoefficient: Int) {
        self.timeCounter = time
        self.scoreCoefficient = scoreCoefficient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ibRecordLabel.text = String(record)
        setupUI()
        fetchQuestion()
        startTimer()
    }
    
    // MARK: - Private method
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func timerAction() {
        timeCounter -= 1
        if timeCounter == 0, score > record  {
            timer?.invalidate()
            record = score
            showMessage(title: "NEW RECORD \(score) points", handler: { [unowned self] in
                self.navigationController?.popToRootViewController(animated: true)
            })
        } else if timeCounter == 0, score <= record {
            showMessage(title: "GAME OVER", handler: { [unowned self] in
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    private func fetchQuestion() {
        CoreDataManager.instance.fetchRandomQuestions(quantity: 1) { [unowned self] questions in
            guard let question = questions.first else { return }
            print(question.answer + 1)
            self.question = question
            self.setupUI()
        }
    }
    
    private func setupUI() {
        ibScoreLabel.text = String(score)
        ibRecordLabel.text = String(record)
        ibTimeCounterLabel.text = String(timeCounter)
//        ibQuestionLabel.text = question?.question
        setupOptionsUI()
        
        
        UIView.transition(with: ibQuestionLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.ibQuestionLabel.text = self?.question?.question
            }, completion: nil)
    }

    private func setupOptionsUI() {
        ibAnswersContentView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let question = question,
              !question.options.isEmpty else { return }
        let numberOfButtonsInLine = 2
        var buttonsInLine = [UIButton]()
        for (index, option) in question.options.enumerated() {
            let button = UIButton()
            button.backgroundColor  = .darkGray
            button.setTitleColor(.white, for: .normal)
            button.setTitle(option, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(answerPressed), for: .touchUpInside)
            buttonsInLine.append(button)
            if (index + 1) % numberOfButtonsInLine == 0 {
                let stackView =  createAnswersHorisontalStackView(whith: buttonsInLine)
                ibAnswersContentView.addArrangedSubview(stackView)
                buttonsInLine.removeAll()
            }
        }
        if !buttonsInLine.isEmpty {
            let stackView =  createAnswersHorisontalStackView(whith: buttonsInLine)
            ibAnswersContentView.addArrangedSubview(stackView)
        }
    }
    
    private func createAnswersHorisontalStackView(whith buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        buttons.forEach { stackView.addArrangedSubview($0) }
        stackView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return stackView
    }
    
    @objc private func answerPressed(_ sender: UIButton) {
        if isCorrectAnswerPressed(sender) {
            HUD.flash(.success, delay: 0.25)
            score += scoreCoefficient
        } else {
            HUD.flash(.error, delay: 0.25)
        }
        fetchQuestion()
    }
    
    private func isCorrectAnswerPressed(_ sender: UIButton) -> Bool {
        let answerIndex = sender.tag
        guard let unwQuestion = question else {
            fatalError("Question not loaded")
        }
        return unwQuestion.answer == answerIndex
    }
}

