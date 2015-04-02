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

class ScannerViewController : UIViewController,
                              UIImagePickerControllerDelegate,
                              UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var usingCamera = true
    
    
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var loggedIn = NSUserDefaults.standardUserDefaults().boolForKey("loggedIn")
        if !loggedIn {
            performSegueWithIdentifier("to_login", sender: self)
        }
        
        menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)

      
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
                    }
                    
                })
                dismissViewControllerAnimated(true, completion: {})
                performSegueWithIdentifier("new_message_segue", sender: self)
            }
        }
        
        
        // Otherwise, let's just go to the photo library:
        else {
            println("photo lib")
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion: nil)
            
        }
    }
    
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
    
    // This function is for when we use the photo library only!
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary) {
        let photo = info[UIImagePickerControllerOriginalImage] as UIImage
        // TODO: Send photo to backend somewhere in here
        
        dismissViewControllerAnimated(true, completion: {})
        performSegueWithIdentifier("new_message_segue", sender: self)
    }
}


