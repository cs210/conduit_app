//
//  CarManagementView.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit
import Foundation
import GoogleAnalytics_iOS_SDK

class CarManagementView : GAITrackedViewController, UITableViewDataSource {
  // we will download from server in the future
  var cars:[Car] = []
  var selectedCarIndex:NSIndexPath!
  @IBOutlet weak var carsTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadCars()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.screenName = "CarManagement"
  }
  
  func loadCars() {
    self.cars = []
    var defaults = NSUserDefaults.standardUserDefaults()
    var sessionToken : String = defaults.valueForKey("session") as! String
    APIModel.get("users/\(sessionToken)/cars", parameters: nil) {(result, error) in
      if error != nil {
        NSLog("Error getting cars list")
        return
      }
      var carlist = result!["cars"]
      if carlist != nil {
        for (var i=0; i<carlist.count; i++){
          var carJSON = carlist[i]
          var car = Car(json: carJSON)
          self.cars.append(car)
        }
      }
      NSLog("Done getting cars")
      self.carsTableView.reloadData()
    }
  }
  
  @IBAction func addCar(sender: AnyObject) {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    var destViewController : AddCarViewController = mainStoryboard.instantiateViewControllerWithIdentifier("addCarView") as! AddCarViewController
    destViewController.carManagementFlag = true
    self.navigationController?.pushViewController(destViewController, animated: true)
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("car_management_item",
      forIndexPath : indexPath) as! UITableViewCell
    
    cell.textLabel?.text = cars[indexPath.row].licensePlate
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cars.count
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    selectedCarIndex = indexPath
    
    // TODO: enable deleting car
  }
  
}