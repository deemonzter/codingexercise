//
//  Network.swift
//  FastDelivery
//
//  Created by Daryl Locsin on 05/07/2018.
//  Copyright © 2018 Daryl Locsin. All rights reserved.
//

import Alamofire
import SwiftyJSON


typealias JSONResponse = ServiceResponse<JSON>

enum ServiceResponse<T> {
    case success(some: T)
    case failure(some: Error)
}

protocol RouterConvertible: URLRequestConvertible {
    
    func getMethod() -> Alamofire.HTTPMethod
    func getPath() -> String
    func getQueryItems() -> [URLQueryItem]?
    func getBody() -> Data?
}
