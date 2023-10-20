//
//  RequestManager.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 18.10.2023.
//


import UIKit
import Alamofire

enum RequestResultCodable<T: Decodable> {
    case success(response: T)
    case error(message: String?)
}

typealias RequestClosure<T:Decodable> = (RequestResultCodable<T>) -> ()

let parseErrorString = "Error, Please try later"
let parseBundleString = "Error on parse data from bundle"

final class RequestManager: RequestInterceptor {

    let decoder = JSONDecoder()
    static let shared = RequestManager()
    
    private var isRequestsAllowed = true
    private let semaphore = DispatchSemaphore(value: 1)
    
    init() {
        AF.session.configuration.timeoutIntervalForRequest = 15.0
        AF.session.configuration.requestCachePolicy = .reloadRevalidatingCacheData
    }
    
    func performRequest<T: Decodable>(_ requestItem: BaseRequestProtocol, to classType: T.Type, completion: @escaping RequestClosure<T>) {
        
        // maintenance tracking
        semaphore.wait()
        if !isRequestsAllowed  { // allow only 
            if let path = requestItem.apiPath(), !path.contains("itunes.apple.com") {
                semaphore.signal()
                return
            }
        }
        semaphore.signal()
        //
        
        let fullPath = requestItem.apiPath() ?? ""
        let parameters: [String : Any] = requestItem.parameters() ?? [:]
        var headers: [String : String] = requestItem.headers() ?? [:]
        
        //setup headers
        headers["Accept"] = "application/json"
      
        let path = requestItem.needEncode() ? fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) : fullPath

        guard let path = path, let fullPathUrl = URL(string: path) else {
            completion(.error(message: "Common.Error"))
            return
        }
        
        let httpHeaders:HTTPHeaders = HTTPHeaders(headers)
        
        guard let request = try? URLRequest(url: fullPathUrl, method: requestItem.method(), headers: httpHeaders) else {
            completion(.error(message: "Common.Error"))
            return
        }
        
        print("request cache policy = \(request.cachePolicy)")
        print("\n🔵 HEADERS \(headers)")
        print("🔵 \(requestItem.method().rawValue) \(fullPath)")
        print("🔵 PARAMS \(parameters) \n")

        let encoding = requestItem.encoding()
        guard var encodedRequest = try? encoding.encode(request, with: parameters) else {
            completion(.error(message: "Common.Error"))
            return
        }
        
        if let jsonData = requestItem.rawData() {
            encodedRequest.httpBody = jsonData
        }
        
        let alamofireRequest: DataRequest = AF.request(encodedRequest, interceptor: self)
        
        alamofireRequest.validate(statusCode: 200..<300).responseDecodable(of: classType, decoder: decoder) { [weak self] response in
                        
            if let respData = response.data,
               let stringValue = String(data: respData, encoding: .utf8),
               let statusCode = response.response?.statusCode,
               let requestUrl = response.request?.url {
                print("\n🟡 RESPONSE \(statusCode) \(requestUrl) \n \(stringValue)")
            }
                        
            switch response.result {
            case .success(let item):
                print("\n🟢 SUCCESS \(item) \n")
                completion(.success(response: item))
            case .failure(let error):
                
                //trying to get parsing error from response
                if let respError = response.error {
                    print("\n🟣 ERROR \(respError) \n")
                }
                
                //trying to get error message from response
                let errorDesc = self?.getErrorMessage(data: response.data) ?? error.localizedDescription
                print("\n🔴 ERROR \(errorDesc) \n")
                completion(.error(message: errorDesc))
            }
        }
    }
    
    func parseJSON<T: Decodable>(from data: Data?, to classType: T.Type, completion: @escaping RequestClosure<T>) {
        guard let jsonData = data else {
            //showAlert(parseErrorString)
            completion(.error(message: parseErrorString))
            return
        }

        var errorStr = parseErrorString
        if let jsonResult = try? decoder.decode(classType, from: jsonData) {
            completion(.success(response: jsonResult))
            return
        } else { //print decode error for debug purposes
            do {
                _ = try decoder.decode(classType, from: jsonData)
            } catch let error {
                errorStr = error.localizedDescription
                print(error)
            }
        }
        if let errorMsg = getErrorMessage(data: jsonData) {
            completion(.error(message: errorMsg))
            return
        }
        completion(.error(message: errorStr))
    }
    
    func getErrorMessage(data: Data?) -> String? {

        guard let jsonData = data, let dict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any] else {  return nil }
        
        if let details = dict["details"] as? [[String: Any]] {
            var totalValue = ""
            for dict in details {
                for key in dict.keys {
                    if let oneValue = dict[key] as? [String] {
                        if !totalValue.isEmpty {
                            totalValue = totalValue + "\n\n"
                        }
                        totalValue += oneValue.joined(separator: "\n")
                        print("totalValue")
                    }
                }
            }
            if !totalValue.isEmpty {
                return totalValue
            }
        }
        
        if let message = dict["message"] as? String {
            return message
        }
        
        return nil
    }
}
