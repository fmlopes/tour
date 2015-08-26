//
//  RegisterViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 8/1/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import CoreData
import MobileCoreServices

class RegisterViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, APIProtocol {
    
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var gendersSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var profileImgButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        
        
        self.birthdayTextField.inputView = birthdayDatePicker
    }
    
    @IBAction func RegisterClick(sender: AnyObject) {
        
        if nameTextField.text.isEmpty {
            println("Nome é obrigatório")
            return
        }
        if emailTextField.text.isEmpty {
            println("Email é obrigatório")
            return
        }
        if passTextField.text.isEmpty {
            println("Senha é obrigatório")
            return
        }
        
        let user:User = User(id: 0, name: nameTextField.text, birthdate: birthdayDatePicker.date, email: emailTextField.text, pass: passTextField.text, gender: gendersSegmentedControl.description, facebookId: 0)
        
        api.HTTPPostJSON("/user", jsonObj: user.dictionaryFromUser())
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
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        
        // Handle a still image capture
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if ( compResult == CFComparisonResult.CompareEqualTo ) {
            
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
            
            if ( editedImage != nil ) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            NSLog("Write To Saved Photos")
            profileImgButton.imageView?.image = imageToSave
            profileImgButton.reloadInputViews()
            
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
        uploadRequest?.key = "profile-imgs/\(name).png"
        uploadRequest?.contentType = "image/png"
        uploadRequest?.body = url
        
        let transferManager:AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
        // start the upload
        transferManager.upload(uploadRequest).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock:{ [unowned self]
            task -> AnyObject in
            
            // once the uploadmanager finishes check if there were any errors
            if(task.error != nil){
                NSLog("%@", task.error)
            }else{
                NSLog("Image uploaded.")
                
                let imageURL = "https://s3-sa-east-1.amazonaws.com/tour-imgs/profile-imgs/\(name).png"
                
            }
            
            return "all done"
            })
        
    }
    
    func resizedImage() -> UIImage {
        let image = self.profileImgButton.imageView?.image!
        
        let rect = AVMakeRectWithAspectRatioInsideRect(image!.size, self.profileImgButton.imageView!.bounds)
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(rect.size, !hasAlpha, scale)
        
        image!.drawInRect(self.profileImgButton.imageView!.bounds)
        
        let scaledImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }

    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            println("Registered")
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as!  UITabBarController
        
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}