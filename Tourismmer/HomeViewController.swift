//
//  HomeViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 02/08/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var groups = [Group]()
    var filteredGroups = [Group]()
    var kCellIdentifier:NSString = "GroupCell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var groupsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var users = [User]()
        users.append(User(id: 0, name: "", birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: 0))
        
        var location = Location(name: "NEW YORK", lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
        
        groups.append(Group(users: users, location: location, date: NSDate(), type: .Business, imgPath: "https://s3-sa-east-1.amazonaws.com/location-imgs-sa-east-1/1.jpg"))
        
        users = [User]()
        users.append(User(id: 0, name: "", birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: 0))
        
        location = Location(name: "BOSTON", lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
        
        groups.append(Group(users: users, location: location, date: NSDate(), type: .Business, imgPath: "https://s3-sa-east-1.amazonaws.com/location-imgs-sa-east-1/2.jpg"))
        
        users = [User]()
        users.append(User(id: 0, name: "", birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: 0))
        
        location = Location(name: "CHICAGO", lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
        
        groups.append(Group(users: users, location: location, date: NSDate(), type: .Business, imgPath: "https://s3-sa-east-1.amazonaws.com/location-imgs-sa-east-1/ny.png"))
        self.groupsTableView!.reloadData()
        
        //self.navigationController.navigationBar.hidden = true
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: Cell = self.groupsTableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as Cell
        var group: Group
        
        if tableView == self.searchDisplayController.searchResultsTableView {
            group = filteredGroups[indexPath.row]
        } else {
            group = groups[indexPath.row]
        }
        
        cell.postText.text = group.location.name.uppercaseString
        if group.type? {
            cell.postGoal.text = group.type?.toRaw().uppercaseString
        }
        cell.postImage.image = UIImage(named: "Blank52.png")
        cell.postDate.text = Util.stringFromDate("MM/yy", date: group.date)
        
        var imgURL:NSURL = NSURL(string:group.imgPath)
        
        let request:NSURLRequest = NSURLRequest(URL: imgURL)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
            if !error? {
                
                cell.postImage.image = UIImage(data: data)
                
            } else {
                println("Error: \(error.localizedDescription)")
            }
            })

        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController.searchResultsTableView {
            return self.filteredGroups.count
        } else {
            return self.groups.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func filterContentForSearchText(searchText: String) {
        self.filteredGroups = self.groups.filter({( group: Group) -> Bool in
            //let match = (scope == "All") || (group.location.name == scope)
            let stringMatch = group.location.name.rangeOfString(searchText).toRange()
            if (stringMatch != nil) {
                return true
            } else {
                return false
            }
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "home_group" {
            let vc = segue.destinationViewController as GroupViewController
            let groupCell = sender as Cell
            
            vc.group.location = Location(name: groupCell.postText.text, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
            vc.group.date = Util.dateFromString("MM/yy", date: groupCell.postDate.text)
            vc.group.type = TripType.fromRaw(groupCell.postGoal.text)
            vc.image = groupCell.postImage.image
        }
    }
}