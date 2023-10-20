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
        let request = GetReposRequest(paginator: paginator, period: .day)
        request.perform { [weak self] in
            switch $0 {
            case .success(let result, let nextLink):
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
    case day
    case week
    case month
    
    var dateString: String {
        switch self {
        case .day:
            return Date.dayAgoDateString
        case .week:
            return Date.weekAgoDateString
        case .month:
            return Date.monthAgoDateString
        }
    }
}
