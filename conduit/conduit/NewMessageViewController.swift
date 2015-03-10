//
//  NewMessageViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 3/8/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class NewMessageViewController : UIViewController, UITableViewDataSource {
    var presetMessages = [
        "Could you please unlock your charging port? Thank you!",
        "When will you be back to your car?",
        "Move your car now or else."
    ]
    
    @IBOutlet weak var presetTable: UITableView!
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presetMessages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style : UITableViewCellStyle.Value2, reuseIdentifier : "PresetListItem")
        
        cell.textLabel?.text = presetMessages[indexPath.row]
        return cell
    }
}
