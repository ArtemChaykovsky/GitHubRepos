//
//  ReposListCoordinator.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 18.10.2023.
//

import UIKit

final class ReposListCoordinator {
    
    private weak var controller = Storyboard.main.controller(withClass: ReposListVC.self)
    private weak var navController: UINavigationController?
    
    init(navController: UINavigationController?) {
        self.navController = navController
        controller?.viewModel = ReposListVM(self)
    }
    
    func start() {
        guard let controller else {
            return
        }
        self.navController?.viewControllers = [controller]
    }
}
