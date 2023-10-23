//
//  TableView.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

extension UITableView {
    
    func registerNib<T: UITableViewCell>(cellType: T.Type) {
        self.register(UINib(nibName: T.nibName, bundle: .main), forCellReuseIdentifier: T.nibName)
    }
    
    func dequeue<T: UITableViewCell>(id: T.Type, for indexPath: IndexPath) -> T? {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.nibName, for: indexPath) as? T else { return UITableViewCell() as? T }
        return cell
    }
}


extension UITableViewCell {
    
    static var nibName: String { return String(describing: self) }
}
