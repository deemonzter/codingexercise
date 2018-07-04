//
//  DeliveryService.swift
//  FastDelivery
//
//  Created by Daryl Locsin on 05/07/2018.
//  Copyright © 2018 Daryl Locsin. All rights reserved.
//

import RxSwift
import CoreLocation


typealias Address = String
typealias DeliveryLocation = (Address, CLLocationCoordinate2D)
typealias DeliveryListResponse = ServiceResponse<[DeliveryItemDTO]>

protocol DeliveryServiceProtocol {
    func requestDeliveries() -> Observable<DeliveryListResponse>
}

struct DeliveryItemDTO: CustomStringConvertible {
    var info: String
    var imageUrl: String
    var location: DeliveryLocation
    
    var description: String {
        return "info:\(info), url:\(imageUrl), location:\(location)"
    }
}
