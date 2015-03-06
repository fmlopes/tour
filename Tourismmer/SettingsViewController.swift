//
//  SettingsViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 3/4/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class SettingsViewController: UITableViewController, FBLoginViewDelegate {
    
    @IBOutlet weak var accountEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountEmail.text = Util.getUserFromDefaults().email
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
        let userFBID:NSNumber = user.objectID.toInt()!
        
        //cadastrar id Facebook
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as UITabBarController
        self.navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }

}