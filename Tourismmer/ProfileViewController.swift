//
//  ProfileViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 5/27/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIProtocol {
    
    var posts = [Post]()
    var kCellIdentifier:NSString = "PostCell_Profile"
    var group:Group = Group()
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        setLayout()
        
        if let user = Util.getUserFromDefaults() {
            nameLabel.text = user.name as String
            api.callback = nil
            api.HTTPGet("/post/getListPostByUser/\(user.id)/50/0")
        }
    }
    
    func setLayout() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!]
        let backButton = UIBarButtonItem(title: "GRUPO", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
        postTableView.hidden = true
        self.activityIndicatorView.startAnimating()
        self.posts.removeAll(keepCapacity: false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ProfilePostCell = self.postTableView.dequeueReusableCellWithIdentifier(kCellIdentifier as String, forIndexPath: indexPath) as! ProfilePostCell
        
        let post: Post = posts[indexPath.row]
        
        cell.post = post
        cell.setCell()
        
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
            
        }
    }
}