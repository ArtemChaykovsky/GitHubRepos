//
//  ReposListTabCoordinator.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

final class ReposListTabCoordinator: TabBarItemCoordinatorType {
    
    let rootController = UINavigationController()
    let tabBarItem: UITabBarItem = UITabBarItem(title: "List", image: UIImage(named: "ic_list"), selectedImage: nil)
    private weak var newCoordinator: ReposListCoordinator?
    
    func start() {
        rootController.tabBarItem = tabBarItem
        let coordinator = ReposListCoordinator(navController: rootController)
        coordinator.start()
    }
}
