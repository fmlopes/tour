//
//  RegisterViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 8/1/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController:UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var genders = [NSString]()
    
    @IBOutlet weak var genderPickerView: UIPickerView!
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genders.append("Masculino")
        genders.append("Feminino")
        genderPickerView.reloadAllComponents()
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return genders[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    @IBAction func RegisterClick(sender: AnyObject) {
        println("Registered")
        
        
    }
}