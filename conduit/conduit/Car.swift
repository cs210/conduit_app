//
//  Car.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation

class Car: APIModel {
 
  var id : Int
  var license_plate: String
  
  init (id: Int, license_plate: String) {
    self.id = id
    self.license_plate = license_plate
  }
  
}