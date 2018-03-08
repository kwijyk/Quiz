//
//  UITableView+Extansion.swift
//  Quiz
//
//  Created by Sergio on 3/8/18.
//  Copyright © 2018 Sergio. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableView {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: ReusableView {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func scrollToTopRow() {
        if let indexPath = indexPathForRow(at: CGPoint(x: 0, y: 0)) {
            scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func scrollToTopRow(in section: Int) {
        let indexPath = IndexPath(row: 0, section: section)
        if cellForRow(at: indexPath) != nil {
            scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func setCenteredActivityIndicatorHidden(_ isHidden: Bool) {
        
        struct DelayedCenteredContent {
            static var tasks: [(tableView: UITableView?, item: DispatchWorkItem?)] = []
        }
        
        // remove current task and not existing tasks
        for (index, object) in DelayedCenteredContent.tasks.enumerated() {
            if object.tableView == nil {
                DelayedCenteredContent.tasks.remove(at: index)
            } else if object.tableView == self {
                object.item?.cancel()
                DelayedCenteredContent.tasks.remove(at: index)
            }
        }
        
        if isHidden {
            (self.backgroundView as? UIActivityIndicatorView)?.stopAnimating()
            self.backgroundView = nil
        } else {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicator.startAnimating()
            self.backgroundView = indicator
            
            let task = DispatchWorkItem { [weak self] in
                self?.setCenteredActivityIndicatorHidden(true)
            }
            DelayedCenteredContent.tasks.append((tableView: self, item: task))
            DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: task)
        }
    }
}
