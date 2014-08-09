//
//  HomeViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 02/08/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groups = [Group]()
    var kCellIdentifier:NSString = "GroupCell"
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var users = [User]()
        users.append(User(id: 0, name: "", city: "", birthdate: NSDate(), email: "", pass: "", gender: "", relationshipStatus: "", facebookId: 0))
        
        var location = Location(name: "New York", lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
        
        
        groups.append(Group(users: users, location: location, date: NSDate(), type: .Business, imgPath: "https://s3-sa-east-1.amazonaws.com/location-imgs-sa-east-1/ny.png"))
        self.groupsTableView!.reloadData()
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let group = groups[indexPath.row]
        
        cell.textLabel.text = group.location.name
        if group.type? {
            cell.detailTextLabel.text = group.type?.toRaw()
        }
        cell.imageView.image = UIImage(named: "Blank52.png")
        
        var imgURL:NSURL = NSURL(string:group.imgPath)
        
        let request:NSURLRequest = NSURLRequest(URL: imgURL)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
            if !error? {
                
                cell.imageView.image = UIImage(data: data)
                
            } else {
                println("Error: \(error.localizedDescription)")
            }
            })

        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
}