//
//  Car.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import SwiftyJSON

class Car: APIModel, NSCoding {
 
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
  
  class func getCarsFromDefaults() -> [Car]? {
    if let data = NSUserDefaults().objectForKey("cars") as? NSData {
      return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Car]
    }
    return nil
  }
  
  class func loadCars(completion: (result: JSON?, error: NSError?) -> ()) {
    var cars: [Car] = []
    var sessionToken : String = NSUserDefaults.standardUserDefaults().valueForKey("session") as! String
    APIModel.get("users/\(sessionToken)/cars", parameters: nil) {(result, error) in
      if error != nil {
        NSLog("Error getting cars list")
        completion(result: nil, error: error)
      }
      var carlist = result!["cars"]
      if carlist != nil {
        for (var i = 0; i < carlist.count; i++){
          var carJSON = carlist[i]
          var car = Car(json: carJSON)
          cars.append(car)
        }
      }
      NSLog("Done getting cars")
      var encodedCars = NSKeyedArchiver.archivedDataWithRootObject(cars)
      NSUserDefaults.standardUserDefaults().setObject(encodedCars, forKey: "cars")
      NSLog("Done encoding cars")

      completion(result: result, error: nil)
    }
  }
  
  required convenience init(coder decoder: NSCoder) {
    var id = decoder.decodeIntegerForKey("id")
    var licensePlate : String = decoder.decodeObjectForKey("licensePlate") as! String
    
    self.init(id: id, licensePlate: licensePlate)
  }
  
  func encodeWithCoder(coder: NSCoder) {
    if self.id != nil {
      coder.encodeInteger(self.id!, forKey:"id")
    }
    coder.encodeObject(self.licensePlate, forKey:"licensePlate")
  }
  
}


