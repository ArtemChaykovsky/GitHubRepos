//
//  AppCoordinator.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 18.10.2023.
//

import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    private let rootNav = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
        start()
    }
    
    deinit {
        print("AppCoordinator - deinit")
    }
    
    private func start() {
        window.rootViewController = rootNav
        let coord = ReposListCoordinator(navController: rootNav)
        coord.start()
    }
}
