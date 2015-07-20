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
    var post:Post = Post()
    lazy var api:API = API(delegate: self)
    
    lazy var composeCommentApi:API = API(delegate: self)
    
    var kCellIdentifier:NSString = "Cell"
    
    var initialViewHeight:CGFloat = 0
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var emptyTableLabel: UILabel!
    @IBOutlet weak var commentInputView: UIView!
    @IBOutlet weak var composeTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        api.HTTPGet("/comment/getListComment/\(self.post.id)/30/0")
    }
    
    func setLayout() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!]
        let backButton = UIBarButtonItem(title: "POST", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
        self.emptyTableLabel.hidden = true
        self.initialViewHeight = self.commentInputView.frame.origin.y
        self.commentsTableView.hidden = true
        self.activityIndicatorView.startAnimating()
        self.composeTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Keyboard stuff.
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        self.composeTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let comment:Comment = Comment()
        comment.text = composeTextField.text
        comment.author = Util.getUserFromDefaults()!
        comment.post = self.post
        
        composeCommentApi.callback = didReceiveComposePostResults
        composeCommentApi.HTTPPostJSON("/comment", jsonObj: comment.dictionaryFromObject())
        return true
    }
    
    @IBAction func postComment(sender: AnyObject) {

        let comment:Comment = Comment()
        comment.text = composeTextField.text
        comment.author = Util.getUserFromDefaults()!
        comment.post = self.post
        
        composeCommentApi.callback = didReceiveComposePostResults
        composeCommentApi.HTTPPostJSON("/comment", jsonObj: comment.dictionaryFromObject())
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: CommentCell = self.commentsTableView.dequeueReusableCellWithIdentifier(kCellIdentifier as String, forIndexPath: indexPath) as! CommentCell
        
        let comment: Comment = comments[indexPath.row]
        
        cell.setCell(comment)
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        self.activityIndicatorView.stopAnimating()
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            
            self.comments.removeAll(keepCapacity: false)
            
            for item in results["listComment"] as! NSArray {
                
                let comment:Comment = Comment()
                comment.text = item["description"] as! String
                let author:NSDictionary = item["author"] as! NSDictionary
                let facebookId:String = author["facebookId"] as! String
                
                let user:User = User(id: author["id"] as! NSNumber, name: author["name"] as! String, birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: strtoll(facebookId, nil, 10))
                
                comment.author = user
                
                comments.append(comment)
            }
            self.commentsTableView!.reloadData()
            self.commentsTableView.hidden = false
            self.emptyTableLabel.hidden = true
        } else if results["statusCode"] as! String == MessageCode.RecordNotFound.rawValue {
            self.emptyTableLabel.hidden = false
        }

    }
    
    func didReceiveComposePostResults(results: NSDictionary) {
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            self.composeTextField.text = ""
            self.composeTextField.resignFirstResponder()
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.bottomConstraint.constant = 0
                }, completion: nil)
            api.HTTPGet("/comment/getListComment/\(self.post.id)/30/0")
        }
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
            var height:CGFloat = 0
        
            if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
                height = tabBarHeight
            }
        
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.bottomConstraint.constant = keyboardSize.size.height - height
            }, completion: nil)
            
        }
    }

}