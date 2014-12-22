//
//  NewGroupViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/25/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class NewGroupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, GoogleServiceProtocol, APIProtocol, UITableViewDelegate, UITableViewDataSource  {
    
    var pickerViewArray:[TripType] = [TripType.Business, TripType.ExchangeProgram, TripType.Tourism, TripType.Excursion]
    var filteredCities = [String]()
    var cities = [String]()
    lazy var googleService:GoogleService = GoogleService(delegate: self)
    lazy var api:API = API(delegate: self)
    @IBOutlet weak var tableViewCities: UITableView!
    
    @IBOutlet weak var pickerViewTripType: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewCities.hidden = true
    }
    
    @IBAction func create(sender: AnyObject) {
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerViewArray[row].rawValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableViewCities.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        cell.textLabel?.text = filteredCities[indexPath.row]
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func filterContentForSearchText(searchText: String) {
        googleService.HTTPGet("/maps/api/place/autocomplete/json?input=\(searchText)&key=AIzaSyC47pgYWvg_sVs5cs2_UXKoIsDPQTo8z7A&language=pt_BR&types=(cities)")
        self.tableViewCities.hidden = false
    }
    
    func didReceiveGoogleResults(results: NSDictionary) {
        print(results)
        
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        print(results)
    }
}