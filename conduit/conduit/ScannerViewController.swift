//
//  ScannerViewController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

// Taken from:
// http://drivecurrent.com/using-swift-and-avfoundation-to-create-a-custom-camera-view-for-an-ios-app/
// https://github.com/DriveCurrent/photo-picker/blob/master/PhotoPicker/ViewController.swift

import Foundation
import UIKit
import AVFoundation
import GoogleAnalytics_iOS_SDK

class ScannerViewController : GAITrackedViewController,
                              UIImagePickerControllerDelegate,
                              UINavigationControllerDelegate {
    
  @IBOutlet weak var cameraView: UIView!
  var captureSession: AVCaptureSession?
  var stillImageOutput: AVCaptureStillImageOutput?
  var previewLayer: AVCaptureVideoPreviewLayer?
  var usingCamera = true
  var licensePlate : String!
    
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  // we turn this flag on when we're adding a car from the car management view
  var addingCarFlag = false
  var carManagementFlag = false
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.screenName = "Scanner"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var sessionKey = NSUserDefaults.standardUserDefaults().stringForKey("session")
    // testing if the session key is actually valid...
    if (sessionKey == nil) {
        performSegueWithIdentifier("to_login", sender: self)
    }
    if addingCarFlag {
      menuButton.hidden = true
    } else {
      menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
      doneButton.hidden = true
    }
  }
  
  

    
    @IBAction func didPressScan(sender: AnyObject) {
        // If we're connected to a camera
        
        // TODO: CAMERA CODE IS UNTESTED
        if usingCamera {
            println("using camera")
            if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
                // Get a still image
                stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                    
                    // Callback happening here
                    if (sampleBuffer != nil) {
                        // Piece together an image from the raw data
                        var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                        var dataProvider = CGDataProviderCreateWithCFData(imageData)
                        var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                        
                        var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                        
                        // We now have an image.
                        // TODO: talk to backend here
                      self.licensePlate = "ABC123" // TODO: This will be come from API call
                      self.proceedWithLicensePlate()
                    }
                    
                })
                dismissViewControllerAnimated(true, completion: {})
              
              
            }
        }
        
        
        // Otherwise, let's just go to the photo library:
        else {
          println("photo lib")
          let imagePicker = UIImagePickerController()
          imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
          imagePicker.delegate = self
          presentViewController(imagePicker, animated: true, completion: {() -> Void in
            self.licensePlate = "ABC123" // TODO: This will be come from API call
            self.proceedWithLicensePlate()
          })

        }
      
    }
 
  @IBAction func enterLicensePlateManually(sender: AnyObject) {
    if addingCarFlag {
      let alertController = UIAlertController(title: "Enter your license plate:", message: "",
        preferredStyle: UIAlertControllerStyle.Alert)
      
      alertController.addTextFieldWithConfigurationHandler({ (textField) in
        textField.text = ""
      })
      
      //3. Grab the value from the text field, and print it when the user clicks OK.
      alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
        let textField = alertController.textFields![0] as! UITextField
        self.licensePlate = textField.text
        self.proceedWithLicensePlate()
      }))
      
      self.presentViewController(alertController, animated: true, completion: nil)
      
      
    } else {
      self.performSegueWithIdentifier("manual_new_message_segue", sender: self)
    }
  }
  
  func proceedWithLicensePlate() {
    if (!addingCarFlag) {
      performSegueWithIdentifier("new_message_segue", sender: self)
    } else {
      // TODO(nisha): manufacturer
      var defaults = NSUserDefaults.standardUserDefaults()
      var sessionToken : String = defaults.valueForKey("session") as! String
      // let params = ["session_token": sessionToken, "license_plate": self.licensePlate, "manufacturer": ""]
      let params = ["license_plate": self.licensePlate, "manufacturer": ""]

      APIModel.post("users/\(sessionToken)/cars", parameters: params) { (result, error) -> () in
        if (error != nil) {
          NSLog("Error creating car")
          let alertController = UIAlertController(title: "", message: "There was an error creating this car. Please try again.",
            preferredStyle: UIAlertControllerStyle.Alert)
          alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
          
          self.presentViewController(alertController, animated: true, completion: nil)
          return
        }
        
        // if there is no error -> create car succeeded!
        
        let alertController = UIAlertController(title: "Car created!", message: "",
          preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Add another car", style: UIAlertActionStyle.Default,handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default,handler: {(action) in
          self.doDoneTransition()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
      }
    }
  }
  
  @IBAction func didPressDoneButton(sender: AnyObject) {
    self.doDoneTransition()
  }
  
  func doDoneTransition() {
    if self.carManagementFlag {
      let prevVC : CarManagementView = self.getPreviousViewController() as! CarManagementView
      prevVC.loadCars()
      self.navigationController?.popViewControllerAnimated(true)
      return
    }
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let destViewController : InviteFriendsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("inviteFriendsView") as! InviteFriendsViewController
    self.navigationController?.pushViewController(destViewController, animated: true)
    
  }
  
  func getPreviousViewController() -> UIViewController? {
    let numVCs = self.navigationController!.viewControllers.count
    
    if numVCs < 2 {
      return nil
    }
    
    return self.navigationController!.viewControllers[numVCs - 2] as! UIViewController
  }
  
  
//  - (UIViewController *)backViewController
//  {
//  NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
//  
//  if (numberOfViewControllers < 2)
//  return nil;
//  else
//  return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
//  }
  
    override func viewDidAppear(animated: Bool) {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
    
        
        // Try to get the back camera as input
        var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError?
        var input = AVCaptureDeviceInput(device: backCamera, error: &error)
        
        // If we're able to connect to the back camera
        if error == nil && captureSession!.canAddInput(input) {
            
            // Set the input method to the back camera
            captureSession!.addInput(input)
            
            // Set the output preferences (i.e. image type)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                // Set up the cameraView as the frame for the camera
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                cameraView.layer.addSublayer(previewLayer)
                previewLayer!.frame = cameraView.bounds
                
                captureSession!.startRunning()
            }
        } else {
            usingCamera = false
        }
    }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let photo = info[UIImagePickerControllerOriginalImage] as! UIImage
        // TODO: Send photo to backend somewhere in here
        
        dismissViewControllerAnimated(true, completion: {})
    }
  
  

  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "new_message_segue" {
      var next = segue.destinationViewController as! NewMessageViewController
      next.licenseTextField.text = licensePlate
      next.manualLicensePlate = false
    } else if segue.identifier == "manual_new_message_segue" {
      var next = segue.destinationViewController as! NewMessageViewController
      next.licensePlate = ""
      next.manualLicensePlate = true
    }
  }

}


