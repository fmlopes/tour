//
//  SearchViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 2/5/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class SearchViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, APIProtocol {
    
    var searchGroupResults:[Group] = [Group]()
    var searchUserResults:[User] = [User]()
    var searchPurposeResults:[TripType] = [TripType]()
    var selectedSearch:String = ""
    lazy var api:API = API(delegate: self)
    var kCellIdentifier:String = "Cell"
    
    @IBOutlet weak var searchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: Cell = self.searchDisplayController?.searchResultsTableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as Cell
        
        if selectedSearch == "LUGARES" {
            var group:Group = searchGroupResults[indexPath.row]
            
            cell.postText.text = group.location.name
            cell.postDate.text = Util.stringFromDate("MMM/yyyy", date: group.date)
            cell.postGoal.text = group.type?.rawValue
        } else if selectedSearch == "PESSOAS" {
            
        } else {
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = 0
        if selectedSearch == "LUGARES" {
            count = searchGroupResults.count
        } else if selectedSearch == "PESSOAS" {
            count = searchUserResults.count
        } else {
            count = searchPurposeResults.count
        }
        return count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func filterContentForSearchText(searchText: String, scope:String = "LUGARES") {
        if scope == "LUGARES" {
            api.HTTPGet("/group/getTopGroups/\(50)/1")
        } else if scope == "PESSOAS" {
            //api.HTTPGet("/group/getTopGroups/\(50)/1")
        } else {
            //api.HTTPGet("/group/getTopGroups/\(50)/1")
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController?.searchBar.scopeButtonTitles as [String]
        let index:Int? = self.searchDisplayController?.searchBar.selectedScopeButtonIndex
        let selectedScope = scopes[index!] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return false
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let scopes = self.searchDisplayController?.searchBar.scopeButtonTitles as [String]
        let index:Int? = self.searchDisplayController?.searchBar.selectedScopeButtonIndex
        let selectedScope = scopes[index!] as String
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return false
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            for item in results["listGroup"] as NSArray {
                var users = [User]()
                users.append(User(id: 0, name: "", birthdate: NSDate(), email: "", pass: "", gender: "", facebookId: 0))
                
                var location = Location(name: item["destination"] as String, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
                
                var purpose:NSDictionary = item["purpose"] as NSDictionary
                var image:NSDictionary = item["image"] as NSDictionary
                var dateString = item["date"] as String
                searchGroupResults.append(Group(users: users, user: User(), location: location.name, date: Util.dateFromString("dd-MM-yyyy", date: dateString), type: TripType.valueFromId(purpose["id"] as Int), imgPath: image["url"] as String, id: item["id"] as Int))
            }

            //self.searchDisplayController?.searchResultsTableView.reloadData()
            self.searchTableView.reloadData()
        }
    }
}
