//
//  API.swift
//  FastDelivery
//
//  Created by Daryl Locsin on 05/07/2018.
//  Copyright © 2018 Daryl Locsin. All rights reserved.
//

import CoreLocation
import RxSwift
import Alamofire
import SwiftyJSON
import RxAlamofire


class Cache {
    
    static func setPayload(_ payload: JSON, withUrl url: URL) {
        UserDefaults.standard.set(String(describing: payload), forKey: url.absoluteString)
        UserDefaults.standard.synchronize()
    }
    
    static func getPayload(withUrl url: URL) -> JSON? {
        if let rawStr = UserDefaults.standard.string(forKey: url.absoluteString) {
            return JSON(parseJSON: rawStr)
        }
        return nil
    }
}

class API {
    
    enum DeliveryRouter {
        case getDeliveries
    }
    
    static let baseUrl = "http://127.0.0.1:8080"
    
    func request(forRoute some: RouterConvertible) -> Observable<JSONResponse> {
        
        let genericError = NSError(domain: "FastDelivery", code: 400, userInfo: nil) as Error
        
        guard let manager = NetworkReachabilityManager() else {
            return Observable<JSONResponse>.just(ServiceResponse.failure(some: genericError))
        }
        
        if manager.isReachable {
            return RxAlamofire.requestJSON(some)
                .timeout(5, scheduler: MainScheduler.instance)
                .map({ (httpUrlResponse, payload) -> JSONResponse in
                    switch httpUrlResponse.statusCode {
                    case 200:
                        let json = JSON(payload)
                        Cache.setPayload(json, withUrl: httpUrlResponse.url!)
                        return ServiceResponse.success(some: json)
                    default:
                        let error = NSError(domain: "FastDelivery", code: 500, userInfo: nil) as Error
                        return ServiceResponse.failure(some: error)
                    }
                })
        } else {
            if let json = Cache.getPayload(withUrl: some.urlRequest!.url!) {
                print("getting from cache...")
                return Observable<JSONResponse>.just(ServiceResponse.success(some: json))
            }
            return Observable<JSONResponse>.just(ServiceResponse.failure(some: genericError))
        }
    }
}

extension API.DeliveryRouter: RouterConvertible {
    
    func getMethod() -> Alamofire.HTTPMethod {
        switch self {
        case .getDeliveries:
            return .get
        }
    }
    
    func getPath() -> String {
        switch self {
        case .getDeliveries:
            return "/deliveries"
        }
    }
    
    func getQueryItems() -> [URLQueryItem]? {
        return nil
    }
    
    func getBody() -> Data? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        let someUrl = NSURL(string: API.baseUrl)?.appendingPathComponent(self.getPath())
        
        if let _someUrl = someUrl {
            let comp = NSURLComponents(string: _someUrl.absoluteString)
            comp?.queryItems = self.getQueryItems()
            
            if let _url = comp?.url {
                let request = NSMutableURLRequest(url: _url)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = self.getMethod().rawValue
                request.httpBody = self.getBody()
                return request as URLRequest
            } else {
                throw AFError.invalidURL(url: someUrl?.absoluteString ?? "empty")
            }
        } else {
            throw AFError.invalidURL(url: someUrl?.absoluteString ?? "empty")
        }
    }
}

extension API: DeliveryServiceProtocol {
    
    func requestDeliveries() -> Observable<DeliveryListResponse> {
        let route = API.DeliveryRouter.getDeliveries
        
        showNetworkActivityOnStatusBar()
        return request(forRoute: route)
            .map({ jsonResponse -> DeliveryListResponse in
                hideNetworkActivityOnStatusBar()
                
                switch jsonResponse {
                case .success(let json):
                    var dtos = [DeliveryItemDTO]()
                    
                    for item in json.arrayValue {
                        let info = item["description"].stringValue
                        let url = item["imageUrl"].stringValue
                        let lat = item["location"]["lat"].doubleValue
                        let lng = item["location"]["lng"].doubleValue
                        let address = item["location"]["address"].stringValue
                        let location = (address, CLLocationCoordinate2D(latitude: lat, longitude: lng))
                        let dto = DeliveryItemDTO(info: info, imageUrl: url, location: location)
                        dtos.append(dto)
                    }
                    
                    return ServiceResponse<[DeliveryItemDTO]>.success(some: dtos)
                    
                case .failure(let error):
                    return ServiceResponse<[DeliveryItemDTO]>.failure(some: error)
                }
            })
    }
}
