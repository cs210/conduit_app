//
//  InviteFriendsViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 4/25/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class InviteFriendsViewController : UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var friendsTableView: UITableView!
  @IBOutlet weak var doneButton: UIButton!
  
  let HEADER_MESSAGE : String = "The more people are on Conduit, the better " +
                 "experience everyone has, so invite your EV-owning friends!\n " +
                 "We'll send them a text message containing a download link " +
                 "to Conduit for you."
  
  let fakeFriends : [String] = ["Abby", "Bob", "Charlie", "Deidre", "Emma", "Frankie", "George", "Harry", "Iris"]
  var selectedFriends : [String] = []
  var sentFriends : [String] = []
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Google Analytics
    AnalyticsHelper.trackScreen("InviteFriends")
  }
  
  override func viewDidLoad() {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    if defaults.boolForKey("isNewAccount") {
      menuButton.hidden = true
    } else {
      menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
      doneButton.hidden = true
    }
    friendsTableView.layer.borderWidth = 1
    friendsTableView.layer.borderColor = StyleColor.getColor(.Grey, brightness: .Light).CGColor
    infoLabel.text = HEADER_MESSAGE
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell") as! FriendsListCell
    cell.friendName.text = fakeFriends[indexPath.row]
    
    var backgroundView : UIView = UIView()
    backgroundView.backgroundColor = StyleColor.getColor(.Accent, brightness: .Light)
    cell.selectedBackgroundView = backgroundView
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fakeFriends.count
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var cell = tableView.cellForRowAtIndexPath(indexPath)
    
    let friend = fakeFriends[indexPath.row]
    let index = find(selectedFriends, friend)
    
    if (index != nil) {
      selectedFriends.removeAtIndex(index!)
    } else {
      selectedFriends.append(friend)
    }
  }
  
  @IBAction func goToScanner(sender: AnyObject) {
    var defaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(false, forKey: "isNewAccount")
    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func inviteFriends(sender: AnyObject) {
    if selectedFriends.count == 0 {
      return
    }
    let alertController = UIAlertController(title: "", message:
      "Send an invitation to conduit to " + String(selectedFriends.count) + " friends?",
      preferredStyle: UIAlertControllerStyle.Alert)
    
    alertController.addAction(UIAlertAction(title: "Yes!", style: UIAlertActionStyle.Default,handler:{(action) in
      
      self.sendMessages()
      
      let sentAlertController = UIAlertController(title: "", message:
        "Message Sent!",
        preferredStyle: UIAlertControllerStyle.Alert)
      
      sentAlertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(sentAlertController, animated: true, completion: nil)
    }))
    
    alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel,handler: nil))
    
    self.presentViewController(alertController, animated: true, completion: nil)
    
  }
  
  func sendMessages() {
    
    // Do sending messages here
    
    
    // Reset things
    for friend in selectedFriends {
      sentFriends.append(friend)
    }
    selectedFriends = []
    
    var i : Int = 0
    while i < fakeFriends.count {
      var cell = friendsTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
      cell?.selected = false
      var friend : String = fakeFriends[i]
      if (contains(sentFriends, friend) == true) {
        println(friend)
        cell?.backgroundColor = StyleColor.getColor(.Grey, brightness: .Light)
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
      }
      i += 1
    }
    
  }
}

class FriendsListCell : UITableViewCell {
  @IBOutlet weak var friendName: UILabel!
  
}