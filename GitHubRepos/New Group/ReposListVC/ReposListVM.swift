//
//  ReposListVM.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 18.10.2023.
//

import UIKit

final class ReposListVM {
    
    private let coordinator: ReposListCoordinator
    let paginator = SimplePaginator(limit: 30, currentOffset: 1)
    
    init(_ coordinator: ReposListCoordinator) {
        self.coordinator = coordinator
    }
    
    func fetchRepos() {
        let request = GetReposRequest(paginator: paginator)
        request.perform { [weak self] in
            switch $0 {
            case .success(let result):
                break
            case .error(let error):
                break
            }
        }
    }
    
    deinit {
        print("ReposListVM - deinit")
    }
}
    
enum RepoTimePeriod: String {
    case day = "1d"
    case week = "1w"
    case month = "1m"
}
