//
//  SettingsViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 3/6/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var fbLoginView: FBSDKLoginButton!
    @IBOutlet weak var accountEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        accountEmail.text = Util.getUserFromDefaults()!.email as String
        
        setLayout()
    }
    
    func setLayout() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!]
        let backButton = UIBarButtonItem(title: "VOLTAR", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            print("Cancelled")
        } else {
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
        
        Util.dropUserFromDefaults()
        
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.pushViewController(loginViewController, animated: false)
    }
    
}
