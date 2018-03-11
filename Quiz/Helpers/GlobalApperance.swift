//
//  GlobalApperance.swift
//  Quiz
//
//  Created by Sergio on 2/26/18.
//  Copyright © 2018 Sergio. All rights reserved.
//

import UIKit

struct GlobalAppearance {
    
    static func setupNavigatioBar() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25),
                                                            NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    static func setupTabBar() {
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.black
    }
}
