//
//  DeliveryListVC.swift
//  FastDelivery
//
//  Created by Daryl Locsin on 05/07/2018.
//  Copyright © 2018 Daryl Locsin. All rights reserved.
//

import UIKit
import SVProgressHUD


class DeliveryListVC: RxController {
    
    private var vm: DeliveryListVMProtocol!
    
    // similar to nib based approach, we explicitly unwrap this as well for ease...
    private var tableView: UITableView!
    
    convenience init(vm: DeliveryListVMProtocol) {
        self.init()
        self.vm = vm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = vm.navTitle
        
        configureUI()
        configureObservation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.vm.getDeliveries()
    }
    
    func configureUI() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(tableView)
        
        tableView.register(DeliveryListCell.classForCoder(), forCellReuseIdentifier: DeliveryListCell.cellIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureObservation() {
        self.vm.state.subscribe(onNext: { [weak self] (state) in
            switch state {
            case .idle:
                SVProgressHUD.dismiss()
                
            case .loading:
                SVProgressHUD.show()
            
            case .success:
                self?.tableView.reloadData()
            }
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
}

extension DeliveryListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.deliveries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryListCell.cellIdentifier, for: indexPath) as! DeliveryListCell
        
        let dto = vm.deliveries[indexPath.row]
        cell.configure(some: dto)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DeliveryListCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dto = vm.deliveries[indexPath.row]
        let detail = CrudeAssembly().getDeliveryDetailController(withSome: dto)
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
