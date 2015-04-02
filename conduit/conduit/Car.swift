//
//  Car.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class Car : NSObject{
  var userIds:[Int] = []
  var licensePlate:String
  
  init (userIds:[Int], licensePlate:String) {
    self.userIds = userIds
    self.licensePlate = licensePlate
  }
}