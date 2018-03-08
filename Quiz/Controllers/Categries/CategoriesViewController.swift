//
//  CategoriesViewController.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/14/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import UIKit
import PKHUD

class CategoriesViewController: UIViewController, Alertable {

    @IBOutlet private weak var ibTableView: UITableView!
        
    private var categoriesArray: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories:"
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(resetDataPressed))
        
        setupTableView()
        getCategoriesData()
    }

    // MARK: - Private methods
    @objc private func resetDataPressed() {
//        DataManager.instance.clearLocalStorage()
//        DataManager.instance.getCategory(page: 4, complition: { [weak self] categories in
//            self?.categoriesArray = categories
//            self?.ibTableView.reloadData()
//        })
//        showMessage(title: "Local Storage is cleared")
    }
    
    private func setupTableView() {
        ibTableView.delegate = self
        ibTableView.dataSource = self
        ibTableView.separatorStyle = .none
        ibTableView.keyboardDismissMode = .onDrag
        ibTableView.register(QuestionTableViewCell.self)
    }
    
    private func getCategoriesData() {
        HUD.showProgress()
        CoreDataManager.instance.fetchCategories { [weak self] fetchedCatecories in
            self?.categoriesArray = fetchedCatecories
            DispatchQueue.main.async {
                HUD.hide()
                self?.ibTableView.reloadData()
            }
        }
    }
    
    private func getCategory(indexPath: IndexPath) -> Category? {
        return categoriesArray[indexPath.row]
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let category = categoriesArray[indexPath.row]
        cell.updateCategoryCell(category: category)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    
        let questionVC = QuestionViewController()
        navigationController?.pushViewController(questionVC, animated: true)
    }
}
