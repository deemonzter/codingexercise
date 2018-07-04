//
//  DeliveryListCell.swift
//  FastDelivery
//
//  Created by Daryl Locsin on 05/07/2018.
//  Copyright © 2018 Daryl Locsin. All rights reserved.
//

import UIKit
import AlamofireImage


protocol CellProtocol {
    static var cellIdentifier: String { get }
    static var cellHeight: CGFloat { get }
}

class DeliveryListCell: UITableViewCell, CellProtocol {
    
    var itemImage: UIImageView!
    var itemLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(some: DeliveryItemDTO) {
        if let url = URL(string: some.imageUrl) {
            itemImage.af_setImage(withURL: url) { [weak self] (response) in
                if let image = response.result.value {
                    self?.itemImage.image = image
                }
            }
        } else {
            itemImage.image = nil
        }
        itemLabel.text = some.info + " at " + some.location.0
    }
    
    private func configureUI() {
        itemImage = UIImageView()
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        
        itemLabel = UILabel()
        itemLabel.numberOfLines = 3
        itemLabel.font = UIFont.systemFont(ofSize: 16)
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(itemImage)
        self.contentView.addSubview(itemLabel)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[image(40)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["image":itemImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["label":itemLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image(40)]-[label]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["image":itemImage, "label":itemLabel]))
    }
    
    static var cellIdentifier: String {
        return "DeliveryListCell"
    }
    
    static var cellHeight: CGFloat {
        return 80
    }
}
