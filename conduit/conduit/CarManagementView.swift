//
//  CarManagementView.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit
import Foundation

class CarManagementView : UIViewController, UITableViewDataSource, UITableViewDelegate {
  // we will download from server in the future
  var cars:[Car] = []
  var selectedCarIndex:NSIndexPath!
  @IBOutlet weak var carsTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadCars()
    carsTableView.delegate = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("CarManagement")
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
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if (editingStyle == UITableViewCellEditingStyle.Delete) {
      println("DELETING \(carsTableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text)")
      var sessionToken = NSUserDefaults().stringForKey("session")
      var carId = cars[indexPath.row].id
      APIModel.delete("users/\(sessionToken!)/cars/\(carId!)", parameters: nil, delete_completion: { (result, error) -> () in
        if (error == nil) {
          self.cars.removeAtIndex(indexPath.row)
          self.carsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
          self.carsTableView.reloadData()
        } else {
          println(error)
        }
        
      })
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
    AnalyticsHelper.trackTouchEvent("delete_car")
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    selectedCarIndex = indexPath
    
    // TODO: enable deleting car
  }
  
}