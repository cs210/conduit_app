//
//  NewMessageViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 3/8/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class NewMessageViewController : UIViewController {
    var presetMessages = [
        "Could you please unlock your charging port? Thank you!",
        "When will you be back to your car?",
        "Move your car now or else."
    ]
    
    @IBOutlet weak var presetTable: UITableView!
    
    override func viewDidLoad() {

    }
    
}