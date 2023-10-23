//
//  FavouritesListTabCoordinator.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 23.10.2023.
//

import UIKit

final class FavouritesListTabCoordinator: TabBarItemCoordinatorType {
    
    let rootController = UINavigationController()
    let tabBarItem: UITabBarItem = UITabBarItem(title: "Favourites", image: UIImage(named: "ic_favourites"), selectedImage: nil)
    private weak var newCoordinator: ReposListCoordinator?
    
    func start() {
        rootController.tabBarItem = tabBarItem
        let coordinator = FavouritesListCoordinator(navController: rootController)
        coordinator.start()
    }
}
