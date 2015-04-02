//
//  CarView.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class CarView : UIViewController {
  @IBOutlet var navBar: UINavigationItem!
  
  var selectedCar:Car!
  
  override func viewDidLoad() {
    navBar.title = selectedCar.licensePlate
  }
}