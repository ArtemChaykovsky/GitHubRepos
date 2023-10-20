//
//  SimplePaginator.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

final class SimplePaginator {
    var limit: Int
    var currentOffset: Int
    
    init(limit: Int, currentOffset: Int) {
        self.limit = limit
        self.currentOffset = currentOffset
    }
}
