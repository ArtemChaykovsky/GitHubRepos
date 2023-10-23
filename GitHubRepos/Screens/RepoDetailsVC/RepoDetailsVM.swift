//
//  RepoDetailsVM.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

final class RepoDetailsVM {

    private let coordinator: RepoDetailsCoordinator
    var repoItem: RepoItem
    
    init(_ coordinator: RepoDetailsCoordinator, repoItem: RepoItem) {
        self.coordinator = coordinator
        self.repoItem = repoItem
    }
}
