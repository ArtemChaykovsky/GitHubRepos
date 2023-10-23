//
//  GetReposRequest.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 19.10.2023.
//

import UIKit
import Alamofire

final class GetReposRequest: BaseRequest {
    
    let period: TimePeriod
    let nextUrl: String?

    init(period: TimePeriod, nextUrl: String?) {
        self.period = period
        self.nextUrl = nextUrl
    }
    
    override func apiPath() -> String? {
        return Api.shared.getReposEndpoint
    }
    
    override func method() -> HTTPMethod {
        return .get
    }
    
    override func parameters() -> [String : Any]? {
        if let nextUrl {
            guard let components = URLComponents(string: nextUrl), let items = components.queryItems else {
                return [:]
            }
            var parameters = [String : Any]()
            for item in items {
                parameters[item.name] = item.value
            }
            return parameters
        }
        let params: [String : Any] = ["page": 1,
                                      "per_page": 100,
                                      "sort": "stars",
                                      "order": "desc",
                                      "q": "created:>\(period.dateString)"]
        return params
    }
    
    func perform(completion: @escaping RequestClosure<ReposResponse>) {
        RequestManager.shared.performRequest(self, to: ReposResponse.self, completion: completion)
    }
}
