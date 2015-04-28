//
//  WelcomeViewController.swift
//  conduit
//
//  Created by Nathan Eidelson on 4/27/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController : UIViewController {
  @IBAction func goToScanner(sender: AnyObject) {
    var view = ScannerViewController()
    view.title = "Add a Car"
    view.addingCarFlag = true
    self.navigationController?.pushViewController(view, animated: true)
  }
  
  
  @IBAction func goToInviteFriends(sender: AnyObject) {
    var view = InviteFriendsViewController()
    self.navigationController?.pushViewController(view, animated: true)
  }
  
}