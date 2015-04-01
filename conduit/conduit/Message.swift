//
//  Message.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation

class Message: APIModel {
  var text: String
  var time_stamp: NSDate
  var carID: Int
  var fromID: Int
  
  init(text:String, time_stamp:NSDate, carID:Int, fromID:Int) {
    self.text = text
    self.time_stamp = time_stamp
    self.carID = carID
    self.fromID = fromID
  }
}