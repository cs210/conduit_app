//
//  PhoneSettingsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 5/1/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

class PhoneSettingsViewController: UIViewController {
  @IBOutlet var phoneField: UITextField!
  
  @IBAction func onSave(sender: AnyObject) {
    var user = User.getUserFromDefaults()
    if user == nil {
      return
    }
    user?.phoneNumber = phoneField.text
    user!.update { (result, error) -> () in
      let alertController = UIAlertController(title: "", message:
        "Your phone number has been updated!", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneField.placeholder = User.getUserFromDefaults()?.phoneNumber
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  @IBAction func onTap(sender: AnyObject) {
    view.endEditing(true)
  }
}
