//
//  MyGroupsViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 1/24/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class MyGroupsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, APIProtocol {
    
    var groups = [Group]()
    var kCellIdentifier:NSString = "GroupCell"
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var groupsTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setLayout()
        
        if let user = Util.getUserFromDefaults() {
            api.HTTPGet("/group/getUserGroups/\(user.id)/50/0/")
        }
    }
    
    func setLayout() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!]
        let backButton = UIBarButtonItem(title: "GRUPOS", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
        self.activityIndicatorView.startAnimating()
        self.groupsTableView.hidden = true
        self.groups.removeAll(keepCapacity: false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: Cell = self.groupsTableView.dequeueReusableCellWithIdentifier(kCellIdentifier as String, forIndexPath: indexPath) as! Cell
        var group: Group
        
        group = groups[indexPath.row]
        
        cell.setCell(group)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "mygroups_group" {
            let vc = segue.destinationViewController as! GroupViewController
            let groupCell = sender as! Cell
            
            vc.group.location = Location(name: groupCell.postText.text!, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
            vc.group.date = Util.dateFromString("MM/yy", date: groupCell.postDate.text!)
            vc.group.type = TripType(rawValue: (groupCell.postGoal.text!))
            vc.image = groupCell.postImage.image!
            vc.group.id = groupCell.id
        }
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        self.activityIndicatorView.stopAnimating()
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            for item in results["listGroup"] as! NSArray {
                var users = [User]()
                users.append(User(id: 0, name: "", birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: 0))
                
                var location = Location(name: item["destination"] as! String, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
                
                var purpose:NSDictionary = item["purpose"] as! NSDictionary
                var image:NSDictionary = item["image"] as! NSDictionary
                var dateString = item["date"] as! String
                groups.append(Group(users: users, user: User(), location: location.name as String, date: Util.dateFromString("dd-MM-yyyy", date: dateString), type: TripType.valueFromId(purpose["id"] as! Int), imgPath: image["url"] as! String, id: item["id"] as! Int))
            }
            self.groupsTableView!.reloadData()
            self.groupsTableView.hidden = false
        }
    }
}