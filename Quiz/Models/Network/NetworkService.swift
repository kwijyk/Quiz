//
//  NetworkService.swift
//  Networking_hw19
//
//  Created by Sergio on 1/3/18.
//  Copyright © 2018 Sergey Intern . All rights reserved.
//

import Foundation
import Alamofire

struct NetworkService {
    
    private static var baseURL: String { return "https://qriusity.com/v1/" }
    
    /// CompletionHandler porformed NOT in the main thread
    static func request(endpoint: Endpoint, completionHandler: ((Result<Any>) -> Void)? = nil) {
        
        let encoding: ParameterEncoding = (endpoint.method == .get || endpoint.method == .delete) ? URLEncoding.default : JSONEncoding.default

        Alamofire.request(baseURL + endpoint.path, method: endpoint.method, parameters: endpoint.parameters, encoding: encoding).responseJSON(queue: DispatchQueue.global()) { networkResponse in
             completionHandler?(networkResponse.result)
        }
    }
}
