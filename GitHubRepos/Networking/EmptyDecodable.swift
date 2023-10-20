//
//  RequestManager.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 19.10.2023.
//

import Alamofire
import Foundation

final class EmptyDecodable: Decodable, EmptyResponse {
    static func emptyValue() -> EmptyDecodable {
        return EmptyDecodable()
    }
    
    init() {
    }
}
