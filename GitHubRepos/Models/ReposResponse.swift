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
    var owner: Owner?
    var description: String?
    var stargazersCount: Int?
    var language: String?
    var forks: Int?
    var name: String?
}

final class Owner: Codable {
    var login: String?
    var avatarUrl: String?
}


