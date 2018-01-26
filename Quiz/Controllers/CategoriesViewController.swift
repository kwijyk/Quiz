//
//  CategoriesViewController.swift
//  Networking_hw19
//
//  Created by Sergey Intern  on 12/14/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import UIKit
import Foundation

class CategoriesViewController: UIViewController {

    
    @IBOutlet private weak var ibProgressView: UIView!
    @IBOutlet private weak var ibTableView: UITableView!
    
    private var gameTimer: Timer!
    private var semiCircleLayer = CAShapeLayer()
    private let radius = 105
    private let startAngel = CGFloat( -Double.pi / 2)
    private var endAngel = CGFloat( -Double.pi / 2)
    
    private var categoriesArray: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories:"
        setupTableView()
        getCategoriesData()
        setupProgressView()
    }

    // MARK: - Private methods
    private func setupProgressView() {
        ibProgressView.isHidden = false
        gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        ibProgressView.layer.addSublayer(semiCircleLayer)
    }
    
    private func setupTableView() {
        ibTableView.delegate = self
        ibTableView.dataSource = self
        ibTableView.separatorStyle = .none
        ibTableView.keyboardDismissMode = .onDrag
        
        ibTableView.register(CategoryCell.nib, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
    }
    
    private func getCategoriesData() {
        DataManager.instance.getCategory { [weak self] categories in
            self?.categoriesArray = categories
            self?.ibTableView.reloadData()
        }
    }
    
    private func getCategory(indexPath: IndexPath) -> Category? {
        return categoriesArray[indexPath.row]
    }
    
    @objc func runTimedCode() {
        endAngel = endAngel + CGFloat(Double.pi / 180)
        
        let circlePath = UIBezierPath(arcCenter: ibProgressView.center, radius: CGFloat(radius), startAngle: startAngel, endAngle: endAngel, clockwise: true)
        
        semiCircleLayer.path = circlePath.cgPath
        semiCircleLayer.strokeColor = UIColor.init(red: 184/255, green: 250/255, blue: 236/255, alpha: 1).cgColor
        semiCircleLayer.fillColor = UIColor.clear.cgColor
        semiCircleLayer.lineWidth = 4
        semiCircleLayer.strokeStart = 0
        semiCircleLayer.strokeEnd  = 1
        
        if endAngel >= CGFloat(Double.pi * 1.5) {
            gameTimer.invalidate()
           ibProgressView.isHidden = true
        }
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
