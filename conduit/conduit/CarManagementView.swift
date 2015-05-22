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
    Car.loadCars { (result, error) -> () in
      self.cars = Car.getCarsFromDefaults()!
      self.carsTableView.reloadData()
    }
    
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
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
    cell.textLabel?.font = UIFont(name: StyleHelpers.FONT_NAME, size: StyleHelpers.FONT_SIZE)
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