//
//  RegisterViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 8/1/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController:UIViewController, APIProtocol {
    
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var gendersSegmentedControl: UISegmentedControl!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        
        self.emailTextField.backgroundColor = UIColor.whiteColor()
        self.emailTextField.alpha = 0.5
        
        self.nameTextField.backgroundColor = UIColor.whiteColor()
        self.nameTextField.alpha = 0.5
        
        self.cityTextField.backgroundColor = UIColor.whiteColor()
        self.passTextField.alpha = 0.5
        
        self.birthdayTextField.inputView = birthdayDatePicker
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
        if passTextField.text.isEmpty {
            println("Senha é obrigatório")
            return
        }
        
        let user:User = User(id: 0, name: nameTextField.text, birthdate: birthdayDatePicker.date, email: emailTextField.text, pass: passTextField.text, gender: gendersSegmentedControl.description, facebookId: 0)
        
        api.HTTPPostJSON("/user", jsonObj: user.dictionaryFromUser())
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            println("Registered")
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as!  UITabBarController
        
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}