//
//  ReposResponse.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

final class ReposResponse: Codable {
    var items: [RepoItem]?
}

final class RepoItem: Codable {
    var id: Int?
    var owner: Owner?
    var description: String?
    var stargazersCount: Int?
    var language: String?
    var forks: Int?
    var name: String?
    var createdAt: String?
    var htmlUrl: String?
    
    func numberOfStarsText() -> String {
        return "Number of stars: \(stargazersCount ?? 0)"
    }
    
    func descriptionText() -> String? {
        if let description, !description.isEmpty {
            return description
        }
        if let name = owner?.login {
            return "This is \(name)'s repository"
        }
        return nil
    }
    
    func isSaved() -> Bool {
        return StorageService.shared.isSaved(item: self)
    }
}

final class Owner: Codable {
    var login: String?
    var avatarUrl: String?
}


