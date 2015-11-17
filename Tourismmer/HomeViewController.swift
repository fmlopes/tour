//
//  HomeViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 02/08/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, APIProtocol {
    
    var groups = [Group]()
    var kCellIdentifier:String = "GroupCell"
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        setLayout()
        
        api.HTTPGet("/group/getTopGroups/\(50)/0")
    }
    
    func setLayout() {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        let backButton = UIBarButtonItem(title: "HOME", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
        self.activityIndicatorView.startAnimating()
        self.groupsTableView.hidden = true
        self.groups.removeAll(keepCapacity: false)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: Cell = self.groupsTableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as! Cell
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
        if segue.identifier == "home_group" {
            let vc = segue.destinationViewController as! GroupViewController
            let groupCell = sender as! Cell
            
            vc.group.location = Location(name: groupCell.postText.text!, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
            vc.group.type = TripType(rawValue: (groupCell.postGoal.text!))
            vc.image = groupCell.postImage.image!
            vc.group.id = groupCell.id
        }
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"]as! String == MessageCode.Success.rawValue) {
            
            for item in results["listGroup"] as! NSArray {
                var users = [User]()
                users.append(User(id: 0, name: "", birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: 0))
        
                let location = Location(name: item["destination"] as! String, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
                
                let purpose:NSDictionary = item["purpose"] as! NSDictionary
                let image:NSDictionary = item["image"]as! NSDictionary
//                let dateString = item["date"] as! String
                let dateString = "01-01-0001"
                groups.append(Group(users: users, user: User(), location: location.name as String, date: Util.dateFromString("dd-MM-yyyy", date: dateString), type: TripType.valueFromId(purpose["id"] as! Int), imgPath: image["url"] as! NSString, id: item["id"] as! Int))
            }
            self.groupsTableView!.reloadData()
            self.groupsTableView.hidden = false
            self.activityIndicatorView.stopAnimating()
        }
    }
}