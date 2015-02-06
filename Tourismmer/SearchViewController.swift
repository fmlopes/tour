//
//  SearchViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 2/5/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class SearchViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, APIProtocol {
    
    var searchResults:[UITableViewCell] = [UITableViewCell]()
    lazy var api:API = API(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func filterContentForSearchText(searchText: String) {
        
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
            
        }
    }
}
