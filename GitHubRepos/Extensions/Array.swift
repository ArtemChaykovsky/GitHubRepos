//
//  Array.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        guard index >= 0 && index < self.count else {
            return nil
        }
        return self[index]
    }
}

