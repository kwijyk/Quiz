//
//  Endpoint.swift
//  Networking_hw19
//
//  Created by Sergio on 1/3/18.
//  Copyright © 2018 Sergey Intern . All rights reserved.
//

import Foundation
import Alamofire

protocol Endpoint {
    
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String : Any]? { get }
}
