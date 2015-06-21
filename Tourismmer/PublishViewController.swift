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
    var scaledImage:UIImage = UIImage()
    var imageName:String = "image_placeholder"
    
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let loggedUser:Dictionary<NSString, AnyObject> = defaults.objectForKey("loggedUser") as! Dictionary<String, AnyObject>
        let stringId:NSString = loggedUser["id"] as! NSString
        user.id = NSNumber(longLong: stringId.longLongValue)
    }
    
    func setLayout() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!]
        let backButton = UIBarButtonItem(title: "PUBLISH", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
        self.previewImageView.hidden = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        self.postTextField.resignFirstResponder()
    }
    
    @IBAction func publishPost(sender: AnyObject) {
        if self.postTextField.text != "" {
            self.publishButton.hidden = true
            self.activityIndicator.startAnimating()
        
            if (self.imageName == "image_placeholder") {
                let post:Post = Post()
                post.text = self.postTextField.text
                post.author = self.user
                post.group = self.group
                post.postType = PostType.valueFromId(1)
                post.imagePath = ""
                
                self.api.callback = nil
                self.api.HTTPPostJSON("/post", jsonObj: post.dictionaryFromObject())
            } else {
                api.callback = didReceiveImageHashAPIResults
                api.HTTPGet("/image/getIdS3Randown")
            }
        } else {
            let alert = UIAlertController(title: "Erro", message: "Você deve digitar um texto para seu post.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                handler: nil))
            
            self.presentViewController(alert, animated: false, completion: nil)
        }
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
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func didReceiveImageHashAPIResults(results: NSDictionary) {
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            uploadToS3(results["sequence"] as! String)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        self.imageName = ""
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        
        // Handle a still image capture
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if ( compResult == CFComparisonResult.CompareEqualTo ) {
            
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
            
            if ( editedImage == nil ) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            NSLog("Write To Saved Photos")
            previewImageView.image = imageToSave
            previewImageView.reloadInputViews()
            self.previewImageView.hidden = false
            
            // Save the new image (original or edited) to the Camera Roll
            UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil)
            
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uploadToS3(name: String){
        
        // get the image from a UIImageView that is displaying the selected Image
        var img:UIImage = resizedImage()
        
        // create a local image that we can use to upload to s3
        var path:NSString = NSTemporaryDirectory().stringByAppendingPathComponent("\(name).png")
        var imageData:NSData = UIImagePNGRepresentation(img)
        imageData.writeToFile(path as String, atomically: true)
        
        // once the image is saved we can use the path to create a local fileurl
        var url:NSURL = NSURL(fileURLWithPath: path as String)!
        
        // next we set up the S3 upload request manager
        var uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = "tour-imgs"
        uploadRequest?.ACL = AWSS3ObjectCannedACL.PublicRead
        uploadRequest?.key = "post-imgs/\(name).png"
        uploadRequest?.contentType = "image/png"
        uploadRequest?.body = url
        
        // we will track progress through an AWSNetworkingUploadProgressBlock
        //uploadRequest?.uploadProgress = {[unowned self](bytesSent:Int64, totalBytesSent:Int64, totalBytesExpectedToSend:Int64) in
            
            //dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                
                
            //})
        //}
        
        // now the upload request is set up we can creat the transfermanger, the credentials are already set up in the app delegate
        let transferManager:AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
        // start the upload
        transferManager.upload(uploadRequest).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock:{ [unowned self]
            task -> AnyObject in
            
            // once the uploadmanager finishes check if there were any errors
            if(task.error != nil){
                NSLog("%@", task.error)
            }else{
                NSLog("Image uploaded.")
                
                let imageURL = "https://s3-sa-east-1.amazonaws.com/tour-imgs/post-imgs/\(name).png"
                
                let post:Post = Post()
                post.text = self.postTextField.text
                post.author = self.user
                post.group = self.group
                post.postType = PostType.valueFromId(1)
                post.imagePath = imageURL
                
                self.api.callback = nil
                self.api.HTTPPostJSON("/post", jsonObj: post.dictionaryFromObject())
            }
            
            return "all done"
        })
        
    }
    
    func resizedImage() -> UIImage {
        let image = self.previewImageView.image!
        
        let rect = AVMakeRectWithAspectRatioInsideRect(image.size, self.previewImageView.bounds)
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(rect.size, !hasAlpha, scale)
        
        image.drawInRect(self.previewImageView.bounds)
        
        let scaledImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}