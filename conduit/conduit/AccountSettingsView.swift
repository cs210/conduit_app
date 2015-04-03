//
//  AccountSettingsView.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class AccountSettingsView : UIViewController {
  
  @IBOutlet var emailField: UITextField!
  @IBOutlet var phoneField: UITextField!
  @IBOutlet var notificationsSwitch: UISwitch!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var emailPlaceholder = NSAttributedString(string: "email@example.com", attributes:[NSForegroundColorAttributeName : UIColor.grayColor()])
    emailField.attributedPlaceholder = emailPlaceholder
    
    var phonePlaceholder = NSAttributedString(string: "123456789", attributes:[NSForegroundColorAttributeName : UIColor.grayColor()])
    
    phoneField.attributedPlaceholder = phonePlaceholder
    var notificationPlaceholder = false
    notificationsSwitch.setOn(notificationPlaceholder, animated: true)
  }
  
}
