//
//  PublishViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 1/25/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation
import AVFoundation

class PublishViewController:UIViewController, APIProtocol {
    
    let captureSession = AVCaptureSession()
    var group:Group = Group()
    var user:User = User()
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var postTextField: UITextField!
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let loggedUser:Dictionary<NSString, AnyObject> = defaults.objectForKey("loggedUser") as Dictionary<String, AnyObject>
        let stringId:NSString = loggedUser["id"] as NSString
        user.id = NSNumber(longLong: stringId.longLongValue)
    }
    
    @IBAction func publishPost(sender: AnyObject) {
        
        let post:Post = Post()
        post.text = postTextField.text
        post.author = user
        post.group = group
        post.postType = PostType.valueFromId(1)
        
        api.HTTPPostJSON("/post", jsonObj: post.dictionaryFromObject())
    }
    
    @IBAction func loadCamera(sender: AnyObject) {
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
    }
    
    func beginSession() {
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            
        }
    }
}