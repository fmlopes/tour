//
//  SearchViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 2/5/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class SearchViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, APIProtocol {
    
    var searchGroupResults:[Group] = [Group]()
    var searchUserResults:[User] = [User]()
    var searchPurposeResults:[TripType] = [TripType]()
    var selectedSearch:String = ""
    lazy var api:API = API(delegate: self)
    var kCellIdentifier:String = "Cell"
    var resultSearchController:UISearchController!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        setLayout()
    }
    
    func setLayout() {
        self.navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        let backButton = UIBarButtonItem(title: "BUSCA", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.searchTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: Cell = self.searchTableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as! Cell
        
        if selectedSearch == "LUGARES" || selectedSearch == "INTERESSE"{
            let group:Group = searchGroupResults[indexPath.row]
            
            cell.postText.text = group.location.name as String
            cell.postGoal.text = group.type?.rawValue
            cell.id = group.id
        } else if selectedSearch == "PESSOAS" {
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = 0
        if selectedSearch == "LUGARES" || selectedSearch == "INTERESSE" {
            count = searchGroupResults.count
        } else if selectedSearch == "PESSOAS" {
            count = searchUserResults.count
        }
        return count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
    
    func filterContentForSearchText(searchText: String, scope:String = "LUGARES") {
        self.selectedSearch = scope
        if scope == "LUGARES" {
            api.HTTPGet("/group/getTripsByFilter/50/0?destination=\(searchText)")
        } else if scope == "INTERESSE" {
            api.HTTPGet("/group/getTripsByFilter/50/0?purpose=\(searchText)")
        } else if scope == "PESSOAS" {
            
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            searchGroupResults.removeAll(keepCapacity: false)
            
            for item in results["listGroup"] as! NSArray {
                var users = [User]()
                users.append(User(id: 0, name: "", birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: 0))
                
                let location = Location(name: item["destination"] as! String, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
                
                let purpose:NSDictionary = item["purpose"] as! NSDictionary
                let image:NSDictionary = item["image"]as! NSDictionary
                let dateString = item["date"] as! String
                searchGroupResults.append(Group(users: users, user: User(), location: location.name as String, date: Util.dateFromString("dd-MM-yyyy", date: dateString), type: TripType.valueFromId(purpose["id"] as! Int), imgPath: image["url"]as! String, id: item["id"] as! Int))
            }
            self.searchTableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        self.resultSearchController.active = false
        if segue.identifier == "search_group" {
            let vc = segue.destinationViewController as! GroupViewController
            let groupCell = sender as! Cell
            
            vc.group.location = Location(name: groupCell.postText.text!, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
            vc.group.type = TripType(rawValue: (groupCell.postGoal.text!))
            //vc.image = groupCell.postImage.image!
            vc.group.id = groupCell.id
        }
    }
}
