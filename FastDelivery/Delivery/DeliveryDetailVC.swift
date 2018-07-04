//
//  DeliveryDetailVC.swift
//  FastDelivery
//
//  Created by Daryl Locsin on 05/07/2018.
//  Copyright © 2018 Daryl Locsin. All rights reserved.
//

import UIKit
import MapKit


class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
}

class DeliveryDetailVC: RxController {
    
    private var dto: DeliveryItemDTO!
    
    private var mapView: MKMapView!
    private var imageView: UIImageView!
    private var infoLabel: UILabel!
    
    convenience init(some: DeliveryItemDTO) {
        self.init()
        dto = some
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Delivery Details"
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.mapView.setCenter(dto.location.1, animated: true)
    }
    
    private func configureUI() {
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let annot = CustomAnnotation()
        annot.title = dto.location.0
        annot.subtitle = dto.info
        annot.coordinate = dto.location.1
        mapView.addAnnotation(annot)
        
        imageView = UIImageView()
        
        if let url = URL(string: dto.imageUrl) {
            imageView.af_setImage(withURL: url) { [weak self] (response) in
                self?.imageView.image = response.result.value
            }
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        infoLabel = UILabel()
        infoLabel.text = dto.info + " at " + dto.location.0
        infoLabel.numberOfLines = 3
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mapView)
        container.addSubview(imageView)
        container.addSubview(infoLabel)
        self.view.addSubview(container)
        
        let dim = self.view.bounds.width
        
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[image(40)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["image":imageView]))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["label":infoLabel]))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image(40)]-[label]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["image":imageView, "label":infoLabel]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[map(dim)]-[container(80)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["dim":dim], views: ["map":mapView, "container":container]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[map(dim)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["dim":dim], views: ["map":mapView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[container]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["container":container]))
    }
}
