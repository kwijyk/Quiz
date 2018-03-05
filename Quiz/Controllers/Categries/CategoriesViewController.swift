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
        DataManager.instance.clearLocalStorage()
        DataManager.instance.getCategory(page: 1, complition: { [weak self] categories in
            self?.categoriesArray = categories
            self?.ibTableView.reloadData()
        })
        showMessage(title: "Local Storage is cleared")
    }
    
    private func setupTableView() {
        ibTableView.delegate = self
        ibTableView.dataSource = self
        ibTableView.separatorStyle = .none
        ibTableView.keyboardDismissMode = .onDrag
        
        ibTableView.register(CategoryCell.nib, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
    }
    
    private func getCategoriesData() {
        HUD.showProgress()
        DataManager.instance.getCategory(page: 1, complition: { [weak self] categories in
            HUD.hide()
            self?.categoriesArray = categories
            self?.ibTableView.reloadData()
        })
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier) as? CategoryCell else { return UITableViewCell ()}
        
        let category = categoriesArray[indexPath.row]
        cell.updateCategoryCell(category: category)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let category = getCategory(indexPath: indexPath) else { return }
        let questionVC = QuestionViewController(category: category, nameCategory: category.name)
        navigationController?.pushViewController(questionVC, animated: true)
    }
}
