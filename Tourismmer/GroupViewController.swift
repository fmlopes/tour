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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.hidden = true
        self.emptyListLabel.hidden = true
        
        self.navigationItem.title = group.location.name
        
        let user:User = Util.getUserFromDefaults()
        
        api.callback = nil
        api.HTTPGet("/post/getListPost/\(group.id)/50/0")
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
        cell.userNameLabel!.text = String(post.author.name)
        cell.post.id = post.id
        
        if post.imagePath != "" {
            let request:NSURLRequest = NSURLRequest(URL: NSURL(string:post.imagePath)!)
        
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
                if !(error? != nil) {
                    cell.postBackgroundImage!.image = UIImage(data: data)
                } else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        } else {
            cell.postBackgroundImage.hidden = true
        }
        facebookPhoto(post.author.profilePicturePath, cell: cell)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            
            for item in results["listPost"] as NSArray {
                let image:NSDictionary = item["image"] as NSDictionary
                let author:NSDictionary = item["author"] as NSDictionary
                
                let user:User = User(id: author["id"] as NSNumber, name: author["name"] as String, birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: (author["facebookId"] as NSString).integerValue)
                
                let postType:NSDictionary = item["typePost"] as NSDictionary
                let postTypeId:Int = (postType["id"] as NSNumber).integerValue
                var imGoingCount = 0
                if item.objectForKey("countUserGo") != nil {
                    imGoingCount = item["countUserGo"] as NSInteger
                }
                var commentCount = 0
                if item.objectForKey("countComment") != nil {
                    commentCount = item["countComment"] as NSInteger
                }
                var likeCount = 0
                if item.objectForKey("countLike") != nil
                {
                    likeCount = item["countLike"] as NSInteger
                }
                let post = Post(id: item["id"] as NSNumber, text: item["description"] as String, imagePath: image["url"] as String, likeCount: likeCount, commentCount: commentCount, imGoingCount: imGoingCount, user: user, comments: [Comment](), postType: PostType.valueFromId(postTypeId), group: Group(), date: NSDate())
                posts.append(post)
            }
            
            self.postTableView!.reloadData()
            self.postTableView.hidden = false
        } else if results["statusCode"] as String == MessageCode.RecordNotFound.rawValue {
            self.emptyListLabel.hidden = false
        }
    }
    
    private func facebookPhoto(profilePicturePath: String, cell:PostCell) -> Void {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "group_newPost" {
            let vc = segue.destinationViewController as PublishViewController
            
            vc.group = self.group
        } else if segue.identifier == "group_post" {
            let vc = segue.destinationViewController as PostViewController
            
            let postCell = sender as PostCell
            
            vc.post.id = postCell.post.id
        }
    }
    
    @IBAction func publishPost(segue:UIStoryboardSegue) {
        
        let publishViewController = segue.sourceViewController as PublishViewController
        
        let post:Post = Post()
        post.text = publishViewController.postTextField.text
        post.author = publishViewController.user
        post.group = group
        post.postType = PostType.valueFromId(1)
        
        api.callback = didReceivePublishResults
        api.HTTPPostJSON("/post", jsonObj: post.dictionaryFromObject())
    }
    
    func didReceivePublishResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            let user:User = Util.getUserFromDefaults()
            api.callback = nil
            api.HTTPGet("/post/getListPost/\(group.id)/50/0")
            self.postTableView.hidden = false
            self.emptyListLabel.hidden = true
        }
    }
}
