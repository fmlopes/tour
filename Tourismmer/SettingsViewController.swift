//
//  SettingsViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 3/6/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, FBLoginViewDelegate {
    
    
    @IBOutlet weak var fbLoginView: FBLoginView!
    @IBOutlet weak var accountEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        accountEmail.text = Util.getUserFromDefaults()!.email
        
        setLayout()
    }
    
    func setLayout() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo", size: 19)!]
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
        
        Util.dropUserFromDefaults()
        
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
}
