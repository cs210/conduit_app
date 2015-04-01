//
//  ConversationsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ConversationsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet weak var menuButton: UIButton!
  
  var users: NSArray = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    menuButton.addTarget(self.revealViewController(), action:"revealToggle:",
                                            forControlEvents:UIControlEvents.TouchUpInside)

    User.get(completion: { (result:JSON?, error:NSError?) in
      if (error == nil) {
        var user_index: NSMutableArray = []
        
        for (key: String, user: JSON) in result! {
      //    NSLog(user)

          user_index.addObject(
            User(
              id:           user["id"].intValue,
              firstName:    user["first"].stringValue,
              lastName:     user["last"].stringValue,
              phoneNumber:  user["phone"].stringValue,
              emailAddress: user["email"].stringValue,
              deviceToken:  user["device_token"].stringValue,
              pushEnabled:  user["push_enabled"].boolValue
            )
          )
        }
        self.users = user_index
      }
      
    })
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style : UITableViewCellStyle.Default, reuseIdentifier : "conversationCell")
    var user = users[indexPath.row] as User
    cell.textLabel?.text = user.firstName
    return cell
  }
  
  
}