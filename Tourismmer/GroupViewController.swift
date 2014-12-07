//
//  GroupViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/4/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class GroupViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts = [Post]()
    var kCellIdentifier:NSString = "PostCell"
    var group:Group = Group()
    var image:UIImage = UIImage()
    
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelGoal: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.toolbar.hidden = false
        
        self.navigationItem.title = group.location.name
        
        var post = Post(text: "Empire State Bora AE!", imagePath: "https://s3-sa-east-1.amazonaws.com/location-imgs-sa-east-1/1.jpg", likeCount: 2, commentCount: 15, imGoingCount: 5, user: User(), comments: [Comment]())
        posts.append(post)
        
        post = Post(text: "Alguém a fim de dar uma volta no Central Park?", imagePath: "https://s3-sa-east-1.amazonaws.com/location-imgs-sa-east-1/1.jpg", likeCount: 2, commentCount: 15, imGoingCount: 5, user: User(), comments: [Comment]())
        posts.append(post)
        
        post = Post(text: "Gata, quer tc?", imagePath: "https://s3-sa-east-1.amazonaws.com/location-imgs-sa-east-1/1.jpg", likeCount: 2, commentCount: 15, imGoingCount: 5, user: User(), comments: [Comment]())
        posts.append(post)
        
        self.postTableView!.reloadData()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: PostCell = self.postTableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as PostCell
        
        let post: Post = posts[indexPath.row]
        cell.postTextLabel!.text = post.text
        cell.postCommentLabel!.text = String(post.commentCount)
        cell.postImGoingCountUser!.text = String(post.imGoingCount)
        cell.postLikesLabel!.text = String(post.likeCount)
        
        let request:NSURLRequest = NSURLRequest(URL: NSURL(string:post.imagePath)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
            if !(error? != nil) {
                cell.postBackgroundImage!.image = UIImage(data: data)
            } else {
                println("Error: \(error.localizedDescription)")
            }
        })
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    
}
