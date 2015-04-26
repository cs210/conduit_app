//
//  InviteFriendsViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 4/25/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class InviteFriendsViewController : UIViewController {
  
  @IBOutlet weak var menuButton: UIButton!
  
  override func viewDidLoad() {
    menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
  }
}