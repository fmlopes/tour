//
//  PostViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 1/25/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class PostViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, APIProtocol {
    
    var comments:[Comment] = [Comment]()
    lazy var api:API = API(delegate: self)
    
    lazy var composeCommentApi:API = API(delegate: self)
    
    var kCellIdentifier:NSString = "CommentCell"
    
    var frameView: UIView!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var composeTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.frameView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        api.HTTPGet("/comment/getListComment/\(1)/\(2)/30/0")
    }
    
    override func viewWillAppear(animated: Bool) {
        // Keyboard stuff.
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        self.composeTextField.resignFirstResponder()
    }
    
    @IBAction func composeComment(sender: AnyObject) {
        composeTextField.becomeFirstResponder()
        postButton.enabled = true
    }
    
    @IBAction func postComment(sender: AnyObject) {
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let loggedUser:Dictionary<NSString, AnyObject> = defaults.objectForKey("loggedUser") as Dictionary<String, AnyObject>
        let author:User = User()
        author.id = (loggedUser["id"] as NSString).integerValue

        let comment:Comment = Comment()
        comment.text = composeTextField.text
        comment.author = User()
        comment.author = author
        
        composeCommentApi.callback = didReceiveComposePostResults
        composeCommentApi.HTTPPostJSON("/comment", jsonObj: comment.dictionaryFromObject())
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: CommentCell = self.commentsTableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as CommentCell
        
        let comment: Comment = comments[indexPath.row]
        cell.userName!.text = comment.author.name
        cell.textLabel!.text = comment.text
        
        facebookPhoto(comment.author.profilePicturePath, cell: cell)
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            
            for item in results["listComment"] as NSArray {
                
                let comment:Comment = Comment()
                comment.text = item["description"] as String
                let author:NSDictionary = item["author"] as NSDictionary
                
                let user:User = User(id: author["id"] as NSNumber, name: author["name"] as String, birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: (author["facebookId"] as NSString).integerValue)
                
                comment.author = user
                
                comments.append(comment)
            }
            self.commentsTableView!.reloadData()
        }

    }
    
    func didReceiveComposePostResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            
            self.commentsTableView!.reloadData()
        }
        
    }
    
    private func facebookPhoto(profilePicturePath: String, cell:CommentCell) -> Void {
        let session = NSURLSession.sharedSession()
        let fullPath:String = "https://graph.facebook.com/v2.2\(profilePicturePath)"
        var request = NSMutableURLRequest(URL: NSURL(string: fullPath.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if((error) != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            if((err?) != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            let dataResult:NSDictionary = jsonResult["data"] as NSDictionary
            dispatch_async(dispatch_get_main_queue(), {
                let requestProfilePicture:NSURLRequest = NSURLRequest(URL: NSURL(string:dataResult["url"] as String)!)
                
                NSURLConnection.sendAsynchronousRequest(requestProfilePicture, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
                    if !(error? != nil) {
                        cell.userPhoto!.image = UIImage(data: data)
                    } else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            })
        })
        task.resume()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        var keyboardHeight:CGFloat = keyboardSize.height
        
        var animationDuration:CGFloat = CGFloat(info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber)
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.composeTextField.frame = CGRectMake(10, (self.composeTextField.frame.origin.y - keyboardHeight + 35), 226, 40)
            }, completion: nil)
        
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        
        var keyboardHeight:CGFloat = keyboardSize.height
        
        var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as CGFloat
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.frameView.frame = CGRectMake(0, (self.frameView.frame.origin.y + keyboardHeight), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
        
    }

}