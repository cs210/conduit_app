//
//  CustomMessageController.swift
//  conduit
//
//  Created by Nisha Masharani on 3/31/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class CustomMessageController : UIViewController {
  
  @IBOutlet weak var textArea: UITextField!
  
  override func viewDidLoad() {
    textArea.selected = true
  }
  
}
