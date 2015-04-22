//
//  Car.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import SwiftyJSON

class Car: APIModel {
 
  var licensePlate: String
  
  init (id: Int, licensePlate: String) {
    self.licensePlate = licensePlate
    super.init(id: id)
  }
  
  // The ONLY place where JSON => attribute mapping occurs
  convenience init(json:JSON) {
    self.init(
      id:           json["id"].intValue,
      licensePlate: json["license_plate"].stringValue
    )
  }
  
//  func description() -> String {
//    return "id:\(self.id)\n" +
//            "licensePlate:\(self.licensePlate)\n"
//  }
  
}