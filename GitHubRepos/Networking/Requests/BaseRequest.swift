//
//  BaseRequest.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 19.10.2023.
//

import UIKit
import Alamofire

protocol BaseRequestProtocol {

    func mockDataName() -> String?
    func method() -> HTTPMethod
    func apiPath() -> String?
    func headers() -> [String : String]?
    func parameters() -> [String : Any]?
    func rawData() -> Data?
    func encoding() -> ParameterEncoding
    func needEncode() -> Bool
    func cachePolicy() -> URLRequest.CachePolicy
}

protocol CustomMap {
    func initMapping<T>(_ type: T.Type, dict: [String: Any]) -> T?
}

class BaseRequest: BaseRequestProtocol {

    func mockDataName() -> String? {
        return nil
    }
    
    func method() -> HTTPMethod {
        return .post
    }

    func apiPath() ->String? {
        return nil
    }
    
    func headers() -> [String : String]? {
        return nil
    }
    
    func parameters() -> [String : Any]? {
        return nil
    }
    
    func rawData() -> Data? {
        return nil
    }
    
    func needEncode() -> Bool {
        return true
    }
    
    func cachePolicy() -> URLRequest.CachePolicy {
        return .returnCacheDataElseLoad
    }

    func encoding() -> ParameterEncoding {
        switch method() {
            case .get:
                return URLEncoding.default
            case .post:
                return JSONEncoding.default
            default:
                return JSONEncoding.default
        }
    }

    func performRequest<T:Decodable>(to classType: T.Type, completion: @escaping RequestClosure<T>) {
        RequestManager.shared.performRequest(self, to: classType, completion: completion)
    }
    
    @discardableResult
    func performRequestAsync<T: Decodable>(to classType: T.Type = EmptyDecodable.self) async throws -> T {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.performRequest(to: classType, completion: { response in
                switch response {
                case .success(let responseObject):
                    if T.self == EmptyDecodable.self, let emptyDecodable = EmptyDecodable() as? T {
                        continuation.resume(returning: emptyDecodable)
                        return
                    }
                    continuation.resume(returning: responseObject)
                case .error(let message):
                    let errorMsg = message ?? parseErrorString
                    continuation.resume(throwing: ErrorType.localError(errorMsg))
                }
            })
        }
    }
}

enum ResponseType {
    case success(r: Any)
    case error(e: String)
}
