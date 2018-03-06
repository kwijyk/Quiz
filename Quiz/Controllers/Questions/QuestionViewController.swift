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
    private let category: Category?
    private let nameCategory: String
    private var questionsArray = [Question]() {
        didSet {
            ibTableView.reloadData()
        }
    }

    init(category: Category? = nil, nameCategory: String) {
        self.category = category
        self.nameCategory = nameCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = nameCategory
        addNotifications()
        setupTableView()
        getQuestionsData()
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        ibTableView.delegate = self
        ibTableView.dataSource = self
        ibTableView.separatorStyle = .none
        ibTableView.keyboardDismissMode = .onDrag
        
        ibTableView.register(CategoryCell.nib, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
    }
    
    static var pageQuestions = 1
    private func getQuestionsData() {
        if let unwCategoty = category {
//            if !CoreDataManager.instance.isQuestionsExist(for: unwCategoty) {
//                HUD.showProgress()
//            }
            DataManager.instance.getQuestions(by: unwCategoty, page: QuestionViewController.pageQuestions)
            QuestionViewController.pageQuestions += 1
//        } else {
//            HUD.showProgress()
//            DataManager.instance.getRandomQuestions(page: 1, complition: { [unowned self] qustions in
//                HUD.hide()
//                self.questionsArray = qustions
//            })
    
        }
    }
        
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: .QestionsLoaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishLoadQuestion), name: .DidFailLoadQestions, object: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier) as? CategoryCell else { return UITableViewCell ()}

        let question = questionsArray[indexPath.row]
        cell.updateQuestionCell(question: question)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let question = questionsArray[indexPath.row]
        let answerVC = AnswerViewController(nameCategory: nameCategory, question: question)
        navigationController?.pushViewController(answerVC, animated: true)
    }
}

// Notification
extension QuestionViewController {
    
    @objc private func questionsLoaded() {
        HUD.hide()
        guard let qustions = DataManager.instance.allQuestions else { return }
        questionsArray = qustions
    }
    
    @objc private func didFinishLoadQuestion(notification: NSNotification) {
        HUD.hide()
        showMessage(title: "Error")
    }
}


