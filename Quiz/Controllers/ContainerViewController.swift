//
//  ContainerViewController.swift
//  Quiz
//
//  Created by Sergio on 2/26/18.
//  Copyright © 2018 Sergio. All rights reserved.
//

import UIKit

class ContainerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoriesVC = CategoriesViewController()
        let navCategoriesVC = UINavigationController(rootViewController: categoriesVC)
        navCategoriesVC.tabBarItem = UITabBarItem(title: "Categories", image: #imageLiteral(resourceName: "icon_categories"), tag: 0)
        
        let randomQuestionVC = QuestionViewController()
        let navRandomQuestionVC = UINavigationController(rootViewController: randomQuestionVC)
        navRandomQuestionVC.tabBarItem = UITabBarItem(title: "Play", image: #imageLiteral(resourceName: "icon_random"), tag: 1)
    
        self.viewControllers = [navCategoriesVC, navRandomQuestionVC]
    }
}
