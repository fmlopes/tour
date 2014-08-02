//
//  RegisterViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 8/1/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController:UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var birthdayPickerView: UIDatePicker!
    @IBOutlet weak var gendersSegmentedControl: UISegmentedControl!
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func RegisterClick(sender: AnyObject) {
        
        if nameTextField.text.isEmpty {
            println("Nome é obrigatório")
            return
        }
        if emailTextField.text.isEmpty {
            println("Email é obrigatório")
            return
        }
        
        println("Registered")
        performSegueWithIdentifier("registeredSegue", sender: self)
    }
}