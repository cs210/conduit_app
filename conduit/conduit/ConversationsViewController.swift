//
//  ConversationsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class ConversationsViewController : UIViewController, UITableViewDataSource {
  var fakeConversations = [
    FakeConversation(licensePlate: "ABC123", lastMessage: "Can I please use your charging station?", lastMessageDate: NSDate(), isUnread: false),
    FakeConversation(licensePlate: "DEF123", lastMessage: "Can I please use your charging station?", lastMessageDate: NSDate(), isUnread: true),
    FakeConversation(licensePlate: "GHJ123", lastMessage: "Thank you so much!", lastMessageDate: NSDate(), isUnread: false),
    FakeConversation(licensePlate: "MNP123", lastMessage: "I'll be back in ten minutes.", lastMessageDate: NSDate(), isUnread: false),
    FakeConversation(licensePlate: "QRS123", lastMessage: "Sorry, I won't be back for a while.", lastMessageDate: NSDate(), isUnread: false)
  ]
  
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
    self.tableView.rowHeight = 70

  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fakeConversations.count
  }
  
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ConversationsListItem", forIndexPath: indexPath) as ConversationsTableViewCell
    
    var conv = fakeConversations[indexPath.row]
    
    // unread messages are bolded
    if conv.isUnread == true {
      cell.licensePlateLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
      cell.latestMessageLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
    } else {    // cells are recycled, so we also have to un-bold read messages
      cell.licensePlateLabel.font = UIFont(name:"HelveticaNeue", size: 16.0)
      cell.latestMessageLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
    }

    cell.licensePlateLabel.text = conv.licensePlate
    cell.latestMessageLabel.text = conv.lastMessage
    
    let formatter = NSDateFormatter()
    let usDateFormat = NSDateFormatter.dateFormatFromTemplate("MMddyy", options: 0, locale: NSLocale(localeIdentifier: "en-US"))
    formatter.dateFormat = usDateFormat
 
    cell.dateLabel.text = formatter.stringFromDate(conv.lastMessageDate)
    return cell
  }
  
  
  
}

class ConversationsTableViewCell : UITableViewCell {
  @IBOutlet weak var licensePlateLabel: UILabel!
  @IBOutlet weak var latestMessageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
}

class FakeConversation {
  var licensePlate : String!
  var lastMessage : String!
  var lastMessageDate : NSDate!
  var isUnread : Bool!
  
  init(licensePlate : String, lastMessage : String, lastMessageDate : NSDate, isUnread : Bool) {
    self.licensePlate = licensePlate
    self.lastMessage = lastMessage
    self.lastMessageDate = lastMessageDate
    self.isUnread = isUnread
  }
}


// Sherman's code to test json
// TODO(sherman): Do we need this?

//    @IBOutlet var timeLabel: UILabel!
//    @IBOutlet var dateLabel: UILabel!
//    @IBOutlet weak var menuButton: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
//
//        let urlAsString = "http://date.jsontest.com"
//        let url = NSURL(string: urlAsString)!
//        let urlSession = NSURLSession.sharedSession()
//
//        //2
//        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
//            if (error != nil) {
//                println(error.localizedDescription)
//            }
//            var err: NSError?
//
//            // 3
//            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
//            if (err != nil) {
//                println("JSON Error \(err!.localizedDescription)")
//            }
//
//            // 4
//            let jsonDate: String! = jsonResult["date"] as NSString
//            let jsonTime: String! = jsonResult["time"] as NSString
//
//            println(jsonDate)
//        })
//        // 5
//        jsonQuery.resume()
//    }