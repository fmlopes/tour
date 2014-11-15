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
        
        labelLocation.text = group.location.name.uppercaseString
        labelDate.text = Util.stringFromDate("MM/yy", date: self.group.date).uppercaseString
        labelGoal.text = self.group.type?.toRaw().uppercaseString
        imagePlace.image = self.image
        
        self.navigationController.navigationBar.hidden = false
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: Cell = self.postTableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as Cell
        
        let request:NSURLRequest = NSURLRequest(URL: NSURL(string:""))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
            if !error? {
                
            } else {
                println("Error: \(error.localizedDescription)")
            }
        })
        
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    
}
