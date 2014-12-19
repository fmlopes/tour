//
//  LoginViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 7/28/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate, APIProtocol {
    
    var user:User = User()
    
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
            let encodedEmail:String = emailTextField.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let encodedPass:String = passTextField.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            api.HTTPGet("/user/\(encodedEmail)/\(encodedPass)")
            
        } else {
            let alert = UIAlertController(title: "Erro", message: "Os campos Email e Senha são obrigatórios.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                handler: nil))
            
            self.presentViewController(alert, animated: false, completion: nil)
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
        let userFBID:Int = (user.objectID as String).toInt()!
        
        self.user.name = user.name
        self.user.email = user.objectForKey("email") as String
        self.user.facebookId = Int64(userFBID)
        self.user.gender = user.objectForKey("gender") as NSString
        self.user.birthdate = Util.dateFromString("MM/dd/yyyy", date: user.objectForKey("birthday") as String)
        
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
        if (results["statusCode"] as NSString == MessageCode.RecordNotFound.rawValue) {
            
            api.HTTPPostJSON("/user", jsonObj: self.user.dictionaryFromUser())
        } else if (results["statusCode"] as NSString == MessageCode.UserNotRegistered.rawValue) {
            
        } else if (results["statusCode"] as NSString == MessageCode.UserOrPassInvalid.rawValue) {
            let alert = UIAlertController(title: "Erro", message: "Email ou senha inválidos.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                handler: nil))
            
            self.presentViewController(alert, animated: false, completion: nil)
        } else {
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Home") as HomeViewController
            self.navigationController?.pushViewController(homeViewController, animated: false)
        }
    }
}


