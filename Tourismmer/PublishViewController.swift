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
        api.callback = didReceiveImageHashAPIResults
        api.HTTPGet("/image/getIdS3Randown")
        
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
    
    func didReceiveImageHashAPIResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            uploadToS3(results["sequence"] as String)
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
    
    func uploadToS3(name: String){
        
        // get the image from a UIImageView that is displaying the selected Image
        var img:UIImage = previewImageView!.image!
        
        // create a local image that we can use to upload to s3
        var path:NSString = NSTemporaryDirectory().stringByAppendingPathComponent("\(name).png")
        var imageData:NSData = UIImagePNGRepresentation(img)
        imageData.writeToFile(path, atomically: true)
        
        // once the image is saved we can use the path to create a local fileurl
        var url:NSURL = NSURL(fileURLWithPath: path)!
        
        // next we set up the S3 upload request manager
        var uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = "tour-imgs"
        uploadRequest?.ACL = AWSS3ObjectCannedACL.PublicRead
        uploadRequest?.key = "post-imgs/\(name).png"
        uploadRequest?.contentType = "image/png"
        uploadRequest?.body = url;
        
        // we will track progress through an AWSNetworkingUploadProgressBlock
        //uploadRequest?.uploadProgress = {[unowned self](bytesSent:Int64, totalBytesSent:Int64, totalBytesExpectedToSend:Int64) in
            
            //dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                
                
            //})
        //}
        
        // now the upload request is set up we can creat the transfermanger, the credentials are already set up in the app delegate
        var transferManager:AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
        // start the upload
        transferManager.upload(uploadRequest).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock:{ [unowned self]
            task -> AnyObject in
            
            // once the uploadmanager finishes check if there were any errors
            if(task.error != nil){
                NSLog("%@", task.error);
            }else{
                NSLog("Image uploaded.");
                
                let imageURL = "https://s3-sa-east-1.amazonaws.com/tour-imgs/post-imgs/\(name).png"
                
                let post:Post = Post()
                post.text = self.postTextField.text
                post.author = self.user
                post.group = self.group
                post.postType = PostType.valueFromId(1)
                post.imagePath = imageURL
                
                self.api.HTTPPostJSON("/post", jsonObj: post.dictionaryFromObject())
            }
            
            return "all done";
        })
        
    }
}