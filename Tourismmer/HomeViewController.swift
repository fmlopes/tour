//
//  HomeViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 02/08/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, APIProtocol {
    
    var groups = [Group]()
    var filteredGroups = [Group]()
    var kCellIdentifier:String = "GroupCell"
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        api.HTTPGet("/group/getTopGroups/\(50)/1")
    }
    
    func setLayout() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!]
        let backButton = UIBarButtonItem(title: "HOME", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
        self.activityIndicatorView.startAnimating()
        self.groupsTableView.hidden = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: Cell = self.groupsTableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as! Cell
        var group: Group
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            group = filteredGroups[indexPath.row]
        } else {
            group = groups[indexPath.row]
        }
        
        cell.postText.text = group.location.name.uppercaseString
        if (group.type  != nil){
            cell.postGoal.text = group.type?.rawValue.uppercaseString
        }
        cell.postImage.image = UIImage(named: "image_placeholder")
        cell.postDate.text = Util.stringFromDate("MM/yy", date: group.date)
        cell.id = group.id
        
        if group.imgPath != "" {
            var imgURL:NSURL = NSURL(string:group.imgPath as String)!
        
            let request:NSURLRequest = NSURLRequest(URL: imgURL)
        
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
                if !(error != nil) {
                
                    cell.postImage.image = UIImage(data: data)
                
                } else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        } else {
            cell.postImage.hidden = true
        }
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
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "home_group" {
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
        if (results["statusCode"]as! String == MessageCode.Success.rawValue) {
            //let array:Array = results["listGroup"] as String
            
            for item in results["listGroup"] as! NSArray {
                var users = [User]()
                users.append(User(id: 0, name: "", birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: 0))
        
                var location = Location(name: item["destination"] as! String, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
                
                var purpose:NSDictionary = item["purpose"] as! NSDictionary
                var image:NSDictionary = item["image"]as! NSDictionary
                var dateString = item["date"] as! String
                groups.append(Group(users: users, user: User(), location: location.name as String, date: Util.dateFromString("dd-MM-yyyy", date: dateString), type: TripType.valueFromId(purpose["id"] as! Int), imgPath: image["url"] as! NSString, id: item["id"] as! Int))
            }
            self.groupsTableView!.reloadData()
            self.groupsTableView.hidden = false
        }
    }
}