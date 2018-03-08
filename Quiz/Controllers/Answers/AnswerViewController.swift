//
//  AnswerViewController.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/18/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import UIKit
import PKHUD

class AnswerViewController: UIViewController, Alertable {

    enum TypeAnswerButton: Int {
        case firstAnswer, secondAnswer, thirdAnswer, forthAnswer
    }
    
    @IBOutlet private weak var ibAnswersContentView: UIStackView!
    @IBOutlet private weak var ibQuestionLabel: UILabel!

    private let question: Question
    var answerComplition: ((Bool) -> Void)?
    
    init(question: Question) {
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ibQuestionLabel.text = question.question
        setupUI()
    }
    
    // MARK: - Private method

    private func setupUI() {
        ibQuestionLabel.text = question.question
        setupOptionsUI()
    }
    
    private func setupOptionsUI() {
        guard  !question.options.isEmpty else { return }
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
            HUD.flash(.success, delay: 1.0, completion: { [weak self] success in
                self?.navigationController?.popViewController(animated: true)
            })
        } else {
            HUD.flash(.error, delay: 1.0, completion: { [weak self] success in
                self?.navigationController?.popViewController(animated: true)
            })
        }
        answerComplition?(isCorrectAnswerPressed(sender))
    }
    
    private func isCorrectAnswerPressed(_ sender: UIButton) -> Bool {
        let answerIndex = sender.tag
        return question.answer == answerIndex
    }
}



