//
//  Helpers.swift
//  FastDelivery
//
//  Created by Daryl Locsin on 05/07/2018.
//  Copyright © 2018 Daryl Locsin. All rights reserved.
//

import UIKit


func showNetworkActivityOnStatusBar() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
}

func hideNetworkActivityOnStatusBar() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
}
