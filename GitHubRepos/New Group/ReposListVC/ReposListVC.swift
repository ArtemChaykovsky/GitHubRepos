//
//  ReposListVC.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 18.10.2023.
//

import UIKit

final class ReposListVC: UIViewController {
    
    var viewModel: ReposListVM!

    override func viewDidLoad() {
        super.viewDidLoad()
        AKActivity.add(to: view)
        viewModel.fetchRepos()
    }
}

