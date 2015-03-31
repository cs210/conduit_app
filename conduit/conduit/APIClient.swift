//
//  APIClient.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let APIURL = "http://0.0.0.0:8080/"

// Define a base API model class, which inplements basic REST functionality.

class APIModel {
  
  class func get(path: String, parameters: [String: AnyObject]? = nil,
                               completion: (result: JSON, error: NSErrorPointer) -> () ){
    let url = "\(APIURL)\(path)"
    NSLog("Preparing for GET request to: \(url)")
    
    NSLog("Class Name: \(NSStringFromClass(self.dynamicType))")
    
    Alamofire.request(.GET, url, parameters: parameters).responseJSON {
      (req, res, json, error) in
      if(error != nil) {
        NSLog("GET Error: \(error)")
        
        completion?(result:nil, error:&error)
      } else {
        var json = JSON(json!)
        NSLog("GET Result: \(json)")
        completion?(result:json, error:nil)
      }
    }
  }
  
  // To think about: how do we extend this for an /id? new function? pass id or include in path?
  
  
  
  
}
