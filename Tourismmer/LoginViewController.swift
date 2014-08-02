//
//  LoginViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 7/28/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    lazy var api:API = API(delegate: LoginDelegate())
    var genders = [NSString]()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        genders.append("Masculino")
        genders.append("Feminino")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        
    }
}

class LoginDelegate:APIProtocol {
    func didReceiveAPIResults(results: NSDictionary)  {
        
    }
}
