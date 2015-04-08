//
//  NavigationController.swift
//  conduit
//
//  Created by Nisha Masharani on 4/8/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class NavigationController : UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationBar.backgroundColor = StyleColor.getColor(.Primary, brightness: .Medium)
    self.navigationBar.barTintColor = StyleColor.getColor(.Primary, brightness: .Medium)
    self.navigationBar.translucent = false
    
    self.navigationBar.tintColor = UIColor.whiteColor()
    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
  }
}