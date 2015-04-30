//
//  ChangeEmailViewController.swift
//  conduit
//
//  Created by Sherman Leung on 4/29/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UIViewController {
  @IBOutlet var emailTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onSave(sender: AnyObject) {
    var user = User.getUserFromDefaults()
    if user == nil {
      return
    }
    user?.emailAddress = emailTextField.text
    user!.update { (result, error) -> () in
      let alertController = UIAlertController(title: "", message:
        "Your email has been updated!", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
