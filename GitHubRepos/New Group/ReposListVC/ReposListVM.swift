//
//  ReposListVM.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 18.10.2023.
//

import UIKit

final class ReposListVM {
    
    private let coordinator: ReposListCoordinator
    private let prefetchProximity = 10
    private var isDataLoading = false
    private var nextUrls: [TimePeriod : String] = [:]
    private var tableViewOffsets: [TimePeriod : Double] = [:]
    var selectedPeriod: TimePeriod = .day
    
    init(_ coordinator: ReposListCoordinator) {
        self.coordinator = coordinator
    }
    
    func fetchRepos(completion: @escaping SimpleClosure<String?>) {
        let nextUrl = nextUrls[selectedPeriod]
        let request = GetReposRequest(period: selectedPeriod, nextUrl: nextUrl)
        isDataLoading = true
        request.perform { [weak self] in
            guard let self else {
                return
            }
            self.isDataLoading = false
            switch $0 {
            case .success(let result, let nextLink):
                if let items = result.items {
                    ReposDataSource.append(items: items, period: self.selectedPeriod)
                }
                self.nextUrls[self.selectedPeriod] = nextLink
                completion(nil)
            case .error(let error):
                completion(error)
                break
            }
        }
    }
    
    func numberOfRows() -> Int {
        return ReposDataSource.numberOfItems(for: selectedPeriod)
    }
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(id: RepoInfoCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.setup(with: ReposDataSource.item(for: indexPath.row, period: selectedPeriod))
        return cell
    }
    
    func needFetchNextItems(currentIndexPath: IndexPath) -> Bool {
        if isDataLoading == true {
            return false
        }
        var items = [RepoItem]()
        switch selectedPeriod {
        case .day:
            items = ReposDataSource.dayRepos
        case .week:
            items = ReposDataSource.weekRepos
        case .month:
            items = ReposDataSource.monthRepos
        }
        return currentIndexPath.row >= items.count - prefetchProximity
    }
    
    func isDataEmpty() -> Bool {
        ReposDataSource.isDataEmpty(for: selectedPeriod)
    }
    
    func saveContentOffset(_ offset: Double) {
       tableViewOffsets[selectedPeriod] = offset
    }
    
    func contentOffset() -> Double {
       return tableViewOffsets[selectedPeriod] ?? 0
    }
    
    func didSelectItem(for indexPath: IndexPath) {
        if let item = ReposDataSource.item(for: indexPath.row, period: selectedPeriod) {
            coordinator.proceedToRepoDetails(repoItem: item)
        }
    }
    
    deinit {
        print("ReposListVM - deinit")
    }
}
    
enum TimePeriod: Int {
    
    case day = 0
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
