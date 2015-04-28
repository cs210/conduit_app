//
//  CarManagementView.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit
import Foundation


//var licensePlate = result!["license_plate"].string!
//let alertController = UIAlertController(title: "", message: "\(licensePlate) has been added to your list of cars.",
//  preferredStyle: UIAlertControllerStyle.Alert)
//var cars = result!["cars"].arrayValue
//var car_strings:[String] = cars.map { $0["license_plate"].string!}
//println(car_strings)


class CarManagementView : UIViewController, UITableViewDataSource {
  // we will download from server in the future
  var cars:[Car] = [
    Car(id:1, licensePlate: "ABC123"),
    Car(id:2, licensePlate: "XYZ789"),
    Car(id:3, licensePlate: "CS210B")
  ]
  
  var selectedCarIndex:NSIndexPath!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // grab cars
    var sessionToken = NSUserDefaults().stringForKey("session") as String?
    APIModel.get("users/car", parameters: ["session_token" : sessionToken!]) {
      (result, error) -> () in
      if (error != nil) {
        return
      }
      for (var i=0; i<result?.count; i++){
        var carJSON = result![i]
        var car = Car(json: carJSON)
        self.cars.append(car)
      }
    }
    println(cars)
  }
  @IBAction func addCar(sender: AnyObject) {
    // go to the scanner object
    
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
      performSegueWithIdentifier("car_segue", sender: self)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "car_segue" {
      var next = segue.destinationViewController as! CarDetailsViewController
      
      // retrieve car from the array of car objects
      next.selectedCar = cars[selectedCarIndex.row]
    }
  }
  
}