//
//  TabBarVC.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

protocol TabBarItemCoordinatorType {
    var rootController: UINavigationController { get }
    var tabBarItem: UITabBarItem { get }
}

final class TabBarCoordinator {

    private weak var window: UIWindow?
    private let tabBarController = UITabBarController()
    private var tabCoordinators:[TabBarItemCoordinatorType] = [] // store references to coordinators to avoid immediately deallocate after init
    
    init(window: UIWindow) {
        self.window = window
        tabBarController.tabBar.barTintColor = RGBColor(240, 240, 240)
        tabBarController.tabBar.tintColor = RGBColor(20, 20, 20)
        
        //tab bar items coordinator init
        let firstTabCoord = ReposListTabCoordinator()
        firstTabCoord.start()
        
        let secondTabCoord = FavouritesListTabCoordinator()
        secondTabCoord.start()
        
        tabCoordinators = [firstTabCoord, secondTabCoord]
        tabBarController.viewControllers = [firstTabCoord.rootController, secondTabCoord.rootController]
    }
    
    func start(animated: Bool = false) {
        guard let window = window else { return }
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

