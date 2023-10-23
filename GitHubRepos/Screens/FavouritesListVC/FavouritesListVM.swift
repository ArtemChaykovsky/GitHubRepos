//
//  FavouritesListVM.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

final class FavouritesListVM {

    private let coordinator: FavouritesListCoordinator
    private var favouriteItems: [RepoItem] = []
    
    init(_ coordinator: FavouritesListCoordinator) {
        self.coordinator = coordinator
    }
    
    func updateInfo() {
        favouriteItems = StorageService.shared.favouriteItems
    }
    
    func numberOfRows() -> Int {
        return favouriteItems.count
    }
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(id: RepoInfoCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        if let item = favouriteItems[safe: indexPath.row] {
            cell.setup(with: item)
        }
        return cell
    }
    
    func didSelectItem(for indexPath: IndexPath) {
        if let item = favouriteItems[safe: indexPath.row] {
            coordinator.proceedToRepoDetails(repoItem: item)
        }
    }
}
