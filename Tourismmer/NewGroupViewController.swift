//
//  NewGroupViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/25/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class NewGroupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, GoogleServiceProtocol, APIProtocol  {
    
    var pickerViewArray:[TripType] = [TripType.Business, TripType.ExchangeProgram, TripType.Tourism, TripType.Excursion]
    var filteredCities = [String]()
    var cities = [String]()
    lazy var googleService:GoogleService = GoogleService(delegate: self)
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var pickerViewTripType: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func filterContentForSearchText(searchText: String) {
        googleService.HTTPGet("/maps/api/place/autocomplete/json?input=\(searchText)&key=&language=pt_BR&types=(cities)")
    }
    
    func didReceiveGoogleResults(results: NSDictionary) {
        print(results)
        
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        print(results)
    }
}