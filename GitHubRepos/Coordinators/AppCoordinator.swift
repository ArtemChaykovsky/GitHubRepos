//
//  AppCoordinator.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 18.10.2023.
//

import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        start()
    }
    
    deinit {
        print("AppCoordinator - deinit")
    }
    
    private func start() {
        let coord = TabBarCoordinator(window: window)
        coord.start()
    }
}
