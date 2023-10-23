//
//  FavouritesListCoordinator.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

final class FavouritesListCoordinator {

    private weak var controller = Storyboard.main.controller(withClass: FavouritesListVC.self)
    private weak var navController: UINavigationController?
    
    init(navController: UINavigationController?) {
        self.navController = navController
        controller?.viewModel = FavouritesListVM(self)
    }
    
    func start() {
        guard let controller else {
            return
        }
        self.navController?.setViewControllers([controller], animated: true)
    }
    
    func proceedToRepoDetails(repoItem: RepoItem) {
        let coord = RepoDetailsCoordinator(navController: navController, repoItem: repoItem)
        coord.start()
    }
}
