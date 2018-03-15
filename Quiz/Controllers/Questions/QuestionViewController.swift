//
//  QuestionViewController.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/14/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import UIKit
import PKHUD

class QuestionViewController: UIViewController, Alertable {

    @IBOutlet private weak var ibScoreLabel: UILabel!
    @IBOutlet private weak var ibRecordLabel: UILabel!
    @IBOutlet private weak var ibLivesLabel: UILabel!
    @IBOutlet private weak var ibTableView: UITableView!
    
    let scoreCoefficient: Int
    
    var livesQuantity: Int {
        didSet {
            ibLivesLabel.text = String(livesQuantity)
        }
    }
    
    private var record: Int {
        return UserDefaults.standard.integer(forKey: Constants.MaxLifeUserScoreKey)
    }
    
    private var score: Int = 0 {
        didSet {
          ibScoreLabel.text = String(score)
        }
    }
    
    private var questionsArray = [Question]() {
        didSet {
            ibTableView.reloadData()
        }
    }

    init(scoreCoefficient: Int, livesQuantity: Int) {
        self.scoreCoefficient = scoreCoefficient
        self.livesQuantity = livesQuantity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupResultView()
        setupTableView()
        getQuestionsData(quantity: livesQuantity)
    }
    
    // MARK: - Private methods
    private func setupResultView() {
        ibLivesLabel.text = String(livesQuantity)
        ibRecordLabel.text = String(record)
    }
    
    private func setupTableView() {
        ibTableView.delegate = self
        ibTableView.dataSource = self
        ibTableView.tableFooterView = UIView(frame: .zero)
        ibTableView.keyboardDismissMode = .onDrag
        ibTableView.register(QuestionTableViewCell.self)
    }
    
    private func getQuestionsData(quantity: Int) {
        CoreDataManager.instance.fetchRandomQuestions(quantity: quantity, complitionHandler: { [unowned self] questions in
            self.questionsArray = questions
            self.ibTableView.reloadData()
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let question = questionsArray[indexPath.row]
        cell.updateQuestionCell(question: question)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = questionsArray[indexPath.row]
        let answerVC = AnswerLifeViewController(question: question, scoreCoefficient: scoreCoefficient, livesQuantity: livesQuantity)
        navigationController?.pushViewController(answerVC, animated: true)
        
        answerVC.answerComplition = { [unowned self] score in
            if self.score < score {
                CoreDataManager.instance.fetchRandomQuestions(quantity: 1, complitionHandler: { [weak self] questions in
                    guard let unwQuestion = questions.first else { return }
                    self?.questionsArray[indexPath.row] = unwQuestion
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                })
                self.score = score
            } else {
                self.questionsArray.remove(at: indexPath.row)
                self.livesQuantity -= 1
            }
        }
    }
}
