//
//  PublishViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 1/25/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreData
import MobileCoreServices

class PublishViewController:UIViewController, APIProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var group:Group = Group()
    var user:User = User()
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let loggedUser:Dictionary<NSString, AnyObject> = defaults.objectForKey("loggedUser") as Dictionary<String, AnyObject>
        let stringId:NSString = loggedUser["id"] as NSString
        user.id = NSNumber(longLong: stringId.longLongValue)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        self.postTextField.resignFirstResponder()
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
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            var mediaTypes: Array<AnyObject> = [kUTTypeImage]
            picker.mediaTypes = mediaTypes
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
            
            
        }
        else{
            NSLog("No Camera.")
        }
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            let groupViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Group") as GroupViewController
            self.navigationController?.pushViewController(groupViewController, animated: false)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        
        // Handle a still image capture
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if ( compResult == CFComparisonResult.CompareEqualTo ) {
            
            editedImage = info[UIImagePickerControllerEditedImage] as UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as UIImage?
            
            if ( editedImage == nil ) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            NSLog("Write To Saved Photos")
            previewImageView.image = imageToSave
            previewImageView.reloadInputViews()
            
            // Save the new image (original or edited) to the Camera Roll
            UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil)
            
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}