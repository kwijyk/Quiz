//
//  NavigationBarConfig .swift
//  Networking_hw19
//
//  Created by Sergio on 12/21/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import UIKit

struct NavigationBarConfig {
    
    static func setupNavigatioBar() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25),
                                                            NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
