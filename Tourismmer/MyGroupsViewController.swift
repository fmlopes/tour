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
    var filteredGroups = [Group]()
    var kCellIdentifier:NSString = "GroupCell"
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        api.HTTPGet("/group/getUserGroups/1/50/0/")
    }
    
    func setLayout() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo", size: 19)!]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: Cell = self.groupsTableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as Cell
        var group: Group
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            group = filteredGroups[indexPath.row]
        } else {
            group = groups[indexPath.row]
        }
        
        cell.postText.text = group.location.name.uppercaseString
        if (group.type?  != nil){
            cell.postGoal.text = group.type?.rawValue.uppercaseString
        }
        cell.postImage.image = UIImage(named: "Blank52.png")
        cell.postDate.text = Util.stringFromDate("MM/yy", date: group.date)
        
        var imgURL:NSURL = NSURL(string:group.imgPath)!
        
        let request:NSURLRequest = NSURLRequest(URL: imgURL)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
            if !(error? != nil) {
                
                cell.postImage.image = UIImage(data: data)
                
            } else {
                println("Error: \(error.localizedDescription)")
            }
        })
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return self.filteredGroups.count
        } else {
            return self.groups.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            //let array:Array = results["listGroup"] as String
            
            for item in results["listGroup"] as NSArray {
                var users = [User]()
                users.append(User(id: 0, name: "", birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: 0))
                
                var location = Location(name: item["destination"] as String, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
                
                var purpose:NSDictionary = item["purpose"] as NSDictionary
                var image:NSDictionary = item["image"] as NSDictionary
                var dateString = item["date"] as String
                groups.append(Group(users: users, user: User(), location: location.name, date: Util.dateFromString("dd-MM-yyyy", date: dateString), type: TripType.valueFromId(purpose["id"] as Int), imgPath: image["url"] as String, id: item["id"] as Int))
            }
            self.groupsTableView!.reloadData()
        }
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
}