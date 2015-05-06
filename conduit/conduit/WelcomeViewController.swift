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
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  @IBAction func goToScanner(sender: AnyObject) {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    var destViewController : AddCarViewController = mainStoryboard.instantiateViewControllerWithIdentifier("addCarView") as! AddCarViewController
    self.navigationController?.pushViewController(destViewController, animated: true)
  }
  
  
  @IBAction func goToInviteFriends(sender: AnyObject) {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let destViewController : InviteFriendsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("inviteFriendsView") as! InviteFriendsViewController
    self.navigationController?.pushViewController(destViewController, animated: true)
  }
  
}