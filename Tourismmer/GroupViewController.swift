//
//  GroupViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/4/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class GroupViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, APIProtocol {
    
    var posts = [Post]()
    var kCellIdentifier:NSString = "PostCell"
    var group:Group = Group()
    var image:UIImage = UIImage()
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelGoal: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewWillAppear(animated: Bool) {
        setLayout()
        
        if let user = Util.getUserFromDefaults() {
            api.callback = nil
            api.HTTPGet("/post/getListPost/\(group.id)/\(user.id)/50/0")
        }
    }
    
    func setLayout() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!]
        let backButton = UIBarButtonItem(title: "GRUPO", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.title = group.location.name as String
        postTableView.hidden = true
        self.emptyListLabel.hidden = true
        self.activityIndicatorView.startAnimating()
        self.posts.removeAll(keepCapacity: false)
        self.postTableView.reloadData()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: PostCell = self.postTableView.dequeueReusableCellWithIdentifier(kCellIdentifier as String, forIndexPath: indexPath) as! PostCell
        
        let post: Post = posts[indexPath.row]
        cell.postTextLabel!.text = post.text as String
        cell.postCommentLabel!.text = String(post.commentCount)
        cell.postImGoingCountUser!.text = String(post.imGoingCount)
        cell.postLikesLabel!.text = String(post.likeCount)
        cell.userNameLabel!.text = String(post.author.name)
        cell.post = post
        
        cell.userHasLiked = post.userHasLiked
        cell.userHasCommented = post.userHasCommented
        cell.userIsGoingThere = post.userIsGoing
        
        if (post.userHasLiked) {
            cell.likeButton.setImage(UIImage(named: "like_active"), forState: UIControlState.Normal)
        }
        
        if (post.userHasCommented) {
            cell.commentButton.setImage(UIImage(named: "comment_active"), forState: UIControlState.Normal)
        }
        
        if (post.userIsGoing) {
            cell.imGoingButton.setImage(UIImage(named: "imgoing_active"), forState: UIControlState.Normal)
        }
        
        if post.imagePath != "" {
            Util.setPostCellImageByURL(post.imagePath as String, cell: cell)
        } else {
            let height:CGFloat = 90
            cell.postBackgroundImage.hidden = true
            cell.shadowView.hidden = true
            cell.likeButton.layer.frame.origin.y = height
            cell.postLikesLabel.layer.frame.origin.y = height + 15
            cell.commentButton.layer.frame.origin.y = height
            cell.postCommentLabel.layer.frame.origin.y = height + 15
            cell.imGoingButton.layer.frame.origin.y = height
            cell.postImGoingCountUser.layer.frame.origin.y = height + 15
        }
        FacebookService.setFacebookPhotoInPostCell(post.author.profilePicturePath, cell: cell)
        
        cell.setLayout()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post: Post = posts[indexPath.row]
        
        if post.imagePath == "" {
            return 140
        } else {
            return 430
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        self.activityIndicatorView.stopAnimating()
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            
            for item in results["listPost"] as! NSArray {
                
                let image:NSDictionary = Util.getJsonOptionalDictionary(item as! NSDictionary, fieldName: "image")
                let imagePath:String = Util.getJsonOptionalString(image, fieldName: "url")
                let author:NSDictionary = item["author"] as! NSDictionary
                
                let user:User = User(id: author["id"] as! NSNumber, name: author["name"] as! String, birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: (author["facebookId"] as! NSString).integerValue)
                
                let postType:NSDictionary = item["typePost"] as! NSDictionary
                let postTypeId:Int = (postType["id"] as! NSNumber).integerValue
                let userHasLiked:Bool = Util.getJsonOptionalBool(item as! NSDictionary, fieldName: "userLiked")
                let userHasCommented = Util.getJsonOptionalBool(item as! NSDictionary, fieldName: "userCommented")
                let userIsGoing = Util.getJsonOptionalBool(item as! NSDictionary, fieldName: "userGo")
                
                var imGoingCount = Util.getJsonOptionalInteger(item as! NSDictionary, fieldName: "countUserGo")
                var commentCount = Util.getJsonOptionalInteger(item as! NSDictionary, fieldName: "countComment")
                var likeCount = Util.getJsonOptionalInteger(item as! NSDictionary, fieldName: "countLike")
                
                let post = Post(id: item["id"] as! NSNumber, text: item["description"] as! String, imagePath: imagePath, likeCount: likeCount, commentCount: commentCount, imGoingCount: imGoingCount, user: user, comments: [Comment](), postType: PostType.valueFromId(postTypeId), group: Group(), date: NSDate(), userHasLiked: userHasLiked, userHasCommented: userHasCommented, userIsGoing: userIsGoing)
                posts.append(post)
            }
            
            self.postTableView!.reloadData()
            self.postTableView.hidden = false
        } else if results["statusCode"] as! String == MessageCode.RecordNotFound.rawValue {
            self.emptyListLabel.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "group_newPost" {
            let vc = segue.destinationViewController as! PublishViewController
            
            vc.group = self.group
        } else if segue.identifier == "group_post" {
            let vc = segue.destinationViewController as! PostViewController
            
            let postCell = sender as! PostCell
            
            vc.post.id = postCell.post.id
        }
    }
    
    @IBAction func publishPost(segue:UIStoryboardSegue) {
        
        let publishViewController = segue.sourceViewController as! PublishViewController
        
        let post:Post = Post()
        post.text = publishViewController.postTextField.text
        post.author = publishViewController.user
        post.group = group
        post.postType = PostType.valueFromId(1)
        
        api.callback = didReceivePublishResults
        api.HTTPPostJSON("/post", jsonObj: post.dictionaryFromObject())
    }
    
    func didReceivePublishResults(results: NSDictionary) {
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            if let user = Util.getUserFromDefaults() {
                api.callback = nil
                api.HTTPGet("/post/getListPost/\(group.id)/\(user.id)/50/0")
                self.postTableView.hidden = false
                self.emptyListLabel.hidden = true
            }
        }
    }
}
