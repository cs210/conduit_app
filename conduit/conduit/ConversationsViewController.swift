//
//  ConversationsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class ConversationsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet weak var menuButton: UIButton!
  
  var users: NSMutableArray = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    menuButton.addTarget(self.revealViewController(), action:"revealToggle:",
                                            forControlEvents:UIControlEvents.TouchUpInside)
    
    User.get("users") { (result:JSON, error:NSErrorPointer) -> () in
      if (!error) {
        
        for (index: String, user: JSON) in result {
          user_index.addObject(
            User(
              id:           user["id"].intValue,
              firstName:    user["first_name"].stringValue,
              lastName:     user["last_name"].stringValue,
              phoneNumber:  user["phone_number"].stringValue,
              emailAddress: user["email_address"].stringValue,
              deviceToken:  user["device_token"].stringValue,
              pushEnabled:  user["push_enabled"].boolValue
            )
          )
        }
        users = user_index
      }
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style : UITableViewCellStyle.Default, reuseIdentifier : "conversationCell")
    
    cell.textLabel?.text = users[indexPath.row].firstName
    return cell
  }
  
  
}