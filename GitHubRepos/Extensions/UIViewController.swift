//
//  UIViewController.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String? = "", message: String?) {
        guard let message = message else { return }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            ac.dismiss(animated: true, completion: nil)
        })
        ac.addAction(action)
        present(ac, animated: true, completion: nil)
    }
}

