//
//  NewGroupViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/25/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class NewGroupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, GoogleServiceProtocol, APIProtocol, UITableViewDataSource, UITableViewDelegate  {
    
    var pickerViewArray:[TripType] = [TripType.Business, TripType.ExchangeProgram, TripType.Vacation, TripType.Excursion, TripType.Snowboarding, TripType.Parachute, TripType.Shopping, TripType.Social, TripType.HikesWaterfalls, ]
    var monthArray:[String] = ["JANEIRO", "FEVEREIRO", "MARÇO", "ABRIL" ,"MAIO" ,"JUNHO", "JULHO", "AGOSTO", "SETEMBRO", "OUTUBRO", "NOVEMBRO", "DEZEMBRO"]
    var yearArray:[Int] = [2015, 2016, 2017, 2018, 2019, 2020]
    
    var selectedMonth:String = "JANEIRO"
    var selectedYear:Int = 2015
    var selectedPurpose:String = "NEGÓCIOS"
    
    var filteredCities = [String]()
    var cities = [String]()
    lazy var googleService:GoogleService = GoogleService(delegate: self)
    lazy var api:API = API(delegate: self)
    var kCellIdentifier:NSString = "CityCell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pickerViewTripType: UIPickerView!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!]
        self.pickerViewArray.sort({ $0.rawValue > $1.rawValue })
    }
    
    @IBAction func create(sender: AnyObject) {
        self.createButton.enabled = false
        let month:String = Util.monthNumberFromString(selectedMonth)
        let year:String = String(selectedYear)
        let stringDate = "01/\(month)/\(year)"
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let loggedUser:Dictionary<NSString, AnyObject> = defaults.objectForKey("loggedUser") as! Dictionary<String, AnyObject>
        let owner:User = User()
        let stringId:NSString = loggedUser["id"] as! NSString
        owner.id = NSNumber(longLong: stringId.longLongValue)
        
        let group:Group = Group(users: [User](), user: owner, location: searchBar.text, date: Util.dateFromString("dd/MM/yyyy", date: stringDate), type: TripType(rawValue: selectedPurpose)!, imgPath: "", id: 0)
        
        api.HTTPPostJSON("/group", jsonObj: group.dictionaryFromGroup())
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 {
            return 2
        } else {
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            if component == 0 {
                return monthArray.count
            } else {
                return yearArray.count
            }
        } else {
            return pickerViewArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 1 {
            if component == 0 {
                return monthArray[row]
            } else {
                return String(yearArray[row])
            }
        } else {
            return pickerViewArray[row].rawValue
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            if component == 0 {
                selectedMonth = monthArray[row]
            } else {
                selectedYear = yearArray[row]
            }
        } else {
            selectedPurpose = pickerViewArray[row].rawValue
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        self.filterContentForSearchText(searchString)
        return false
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return false
    }
    
    func filterContentForSearchText(searchText: String) {
        googleService.HTTPGet("/maps/api/place/autocomplete/json?input=\(searchText)&key=AIzaSyC47pgYWvg_sVs5cs2_UXKoIsDPQTo8z7A&language=pt_BR&types=(cities)")
        //println("filter called")
    }
    
    func didReceiveGoogleResults(results: NSDictionary) {
        let array: Array = results["predictions"] as! Array<Dictionary<String, AnyObject>>
        self.cities.removeAll(keepCapacity: false)
        for item in array {
            cities.append(item["description"] as! NSString as String)
        }
        
        self.searchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            let groupViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Group") as! GroupViewController
            let groupId:NSNumber = results["id"] as! NSNumber
            groupViewController.group.id = groupId
            groupViewController.group.location.name = searchBar.text
            
            //Custom back button
            var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            myBackButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
            myBackButton.setTitle("<", forState: UIControlState.Normal)
            myBackButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            myBackButton.sizeToFit()
            var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
            myCustomBackButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!], forState: UIControlState.Normal)
            groupViewController.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
            
            self.navigationController?.pushViewController(groupViewController, animated: false)
            self.createButton.enabled = true
        }
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell()
        
        cell.textLabel?.text = cities[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchDisplayController?.setActive(false, animated: true)
        searchBar.text = cities[indexPath.row]
    }
}