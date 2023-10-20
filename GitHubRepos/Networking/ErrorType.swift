//
//  ErrorType.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 18.10.2023.
//

import Foundation

enum ErrorType: LocalizedError {
    case localError(String)
    case error(Error)
    
    var errorDescription: String? {
        switch self {
        case .localError(let string):
            return string
        case .error(let originalError):
            return originalError.localizedDescription
        }
    }
}
