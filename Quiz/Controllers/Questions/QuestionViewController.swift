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

    @IBOutlet private weak var ibTableView: UITableView!
    
    private var questionsArray = [Question]() {
        didSet {
            ibTableView.reloadData()
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getQuestionsData(quantity: 4)
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        ibTableView.delegate = self
        ibTableView.dataSource = self
        ibTableView.separatorStyle = .none
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
        let answerVC = AnswerViewController(question: question)
        navigationController?.pushViewController(answerVC, animated: true)
        
        answerVC.answerComplition = { [unowned self] trueAnswer in
            if trueAnswer {
                CoreDataManager.instance.fetchRandomQuestions(quantity: 1, complitionHandler: { [weak self] questions in
                    guard let unwQuestion = questions.first else { return }
                    self?.questionsArray[indexPath.row] = unwQuestion
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                })
            } else {
                self.questionsArray.remove(at: indexPath.row)
            }
        }
    }
}
