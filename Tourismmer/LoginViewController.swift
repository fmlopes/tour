//
//  LoginViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 7/28/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate, APIProtocol {
    
    @IBOutlet weak var fbLoginView: FBLoginView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    lazy var api:API = API(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        if (isValidForm()) {
            let encodedEmail = emailTextField.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let encodedPass = passTextField.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            api.HTTPGet("/user/\(encodedEmail)/\(encodedPass)")
            
            let homeViewController = self.storyboard.instantiateViewControllerWithIdentifier("Home") as HomeViewController
            
            self.navigationController.pushViewController(homeViewController, animated: false)
        }
    }
    
    func isValidForm() -> Bool {
        if (emailTextField.text.isEmpty || passTextField.text.isEmpty) {
            return false
        }
        
        return true
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
        
        api.HTTPGet("/user/facebook/\(user.objectID)")
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    func didReceiveAPIResults(results: NSDictionary)  {
        println(results)
        if (results["statusCode"] as NSString == MessageCode.RecordNotFound.toRaw()) {
            let user:User = User(id: 0, name: nameTextField.text, city: "", birthdate: birthdayPickerView.date, email: emailTextField.text, pass: passTextField.text, gender: gendersSegmentedControl.description, relationshipStatus: "", facebookId: 0)
            
            api.HTTPPostJSON("/user", jsonObj: user.dictionaryFromUser())
        } else {
            let homeViewController = self.storyboard.instantiateViewControllerWithIdentifier("Home") as HomeViewController
            self.navigationController.pushViewController(homeViewController, animated: false)
        }
    }
}


