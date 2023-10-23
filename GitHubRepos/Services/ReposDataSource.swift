//
//  ReposDataSource.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

final class ReposDataSource {
    
    static var dayRepos: [RepoItem] = []
    static var weekRepos: [RepoItem] = []
    static var monthRepos: [RepoItem] = []
    
    static var dayReposNextUrl: String?
    static var weekReposNextUrl: String?
    static var monthReposNextUrl: String?
    
    static func append(items: [RepoItem], period: TimePeriod) {
        switch period {
        case .day:
            dayRepos.append(contentsOf: items)
        case .week:
            weekRepos.append(contentsOf: items)
        case .month:
            monthRepos.append(contentsOf: items)
        }
    }
    
    static func numberOfItems(for period: TimePeriod) -> Int {
        switch period {
        case .day:
            return dayRepos.count
        case .week:
            return weekRepos.count
        case .month:
            return monthRepos.count
        }
    }
    
    static func item(for row: Int, period: TimePeriod) -> RepoItem? {
        switch period {
        case .day:
            return dayRepos[safe: row]
        case .week:
            return weekRepos[safe: row]
        case .month:
            return monthRepos[safe: row]
        }
    }
    
    static func isDataEmpty(for period: TimePeriod) -> Bool {
        switch period {
        case .day:
            return dayRepos.isEmpty
        case .week:
            return weekRepos.isEmpty
        case .month:
            return monthRepos.isEmpty
        }
    }
}
