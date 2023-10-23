//
//  RepoDetailsCoordinator.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

final class RepoDetailsCoordinator {

    private weak var controller = Storyboard.main.controller(withClass: RepoDetailsVC.self)
    private weak var navController: UINavigationController?
    
    init(navController: UINavigationController?, repoItem: RepoItem) {
        self.navController = navController
        controller?.viewModel = RepoDetailsVM(self, repoItem: repoItem)
    }
    
    func start() {
        guard let controller else {
            return
        }
        self.navController?.pushViewController(controller, animated: true)
    }
}
