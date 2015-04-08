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
    
    self.navigationBar.tintColor = TextColor.getTextColor(.Light)
    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : TextColor.getTextColor(.Light)]
  }
}