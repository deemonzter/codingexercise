//
//  DeliveryListVM.swift
//  FastDelivery
//
//  Created by Daryl Locsin on 05/07/2018.
//  Copyright © 2018 Daryl Locsin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


enum DeliveryListState {
    case idle
    case loading
    case success
}

protocol DeliveryListVMProtocol {
    var navTitle: String { get }
    var state: Observable<DeliveryListState> { get }
    var deliveries: [DeliveryItemDTO] { get }
    
    func getDeliveries()
}

class DeliveryListVM: RxObject, DeliveryListVMProtocol {
    
    private var service: DeliveryServiceProtocol
    
    init(service: DeliveryServiceProtocol) {
        self.service = service
    }
    
    var navTitle: String {
        return "Things to Deliver"
    }
    
    private var subject = BehaviorSubject<DeliveryListState>(value: .idle)
    
    var state: Observable<DeliveryListState> {
        return subject.asObservable()
    }
    
    private var _deliveries = [DeliveryItemDTO]()
    
    var deliveries: [DeliveryItemDTO] {
        return _deliveries
    }
    
    func getDeliveries() {
        service.requestDeliveries().subscribe(onNext: { [weak self] response in
            switch response {
            case .success(let some):
                self?._deliveries = some
                self?.subject.onNext(.success)
            case .failure:
                self?.subject.onNext(.idle) // for now
            }
        }, onError: { [weak self] error in
            self?.subject.onNext(.idle) // for now
        }).disposed(by: self.disposeBag)
    }
}
