//
//  CarDetailsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 4/25/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit
import GoogleAnalytics_iOS_SDK

class CarDetailsViewController: GAITrackedViewController {

    @IBOutlet var navBar: UINavigationItem!
    
    var selectedCar:Car!
    
    override func viewDidLoad() {
      navBar.title = selectedCar.licensePlate
      self.screenName = "CarDetails"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
