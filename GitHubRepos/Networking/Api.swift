//
//  Api.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 19.10.2023.
//

import UIKit

final class Api {

    static let shared = Api()
    var baseURL = "https://api.github.com"
    
    var getReposEndpoint: String { return "\(baseURL)/search/repositories" }
}
