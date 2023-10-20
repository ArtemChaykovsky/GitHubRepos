//
//  GetReposRequest.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 19.10.2023.
//

import UIKit
import Alamofire

final class GetReposRequest: BaseRequest {
    
    let paginator: SimplePaginator

    init(paginator: SimplePaginator) {
        self.paginator = paginator
    }
    
    override func apiPath() -> String? {
        return Api.shared.getReposEndpoint
    }
    
    override func method() -> HTTPMethod {
        return .get
    }
    
    override func parameters() -> [String : Any]? {
        let params: [String : Any] = ["page": paginator.currentOffset,
                                      "per_page": paginator.limit,
                                      "sort": "stars",
                                      "order": "desc",
                                      "q": "created:>"]
        return params
    }
    
    func perform(completion: @escaping RequestClosure<ReposResponse>) {
        RequestManager.shared.performRequest(self, to: ReposResponse.self, completion: completion)
    }
}
