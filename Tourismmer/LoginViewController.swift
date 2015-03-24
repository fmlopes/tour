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
    
    @IBOutlet weak var recoverPassButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var fbLoginView: FBLoginView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    lazy var api:API = API(delegate: self)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTextField.hidden = true
        passTextField.hidden = true
        loginButton.hidden = true
        fbLoginView.hidden = true
        registerButton.hidden = true
        recoverPassButton.hidden = true
        
        self.navigationController?.navigationBarHidden = true
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        if let u = Util.getUserFromDefaults()
        {
            self.user = u
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as UITabBarController
            self.navigationController?.pushViewController(homeViewController, animated: false)
            
        } else {
            
            self.emailTextField.backgroundColor = UIColor.whiteColor()
            self.emailTextField.alpha = 0.3
            
            self.passTextField.backgroundColor = UIColor.whiteColor()
            self.passTextField.alpha = 0.3
            
            emailTextField.hidden = false
            passTextField.hidden = false
            loginButton.hidden = false
            fbLoginView.hidden = false
            registerButton.hidden = false
            recoverPassButton.hidden = false
        }
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
        
        if Util.getUserFromDefaults() == nil
        {
            let userFBID:NSNumber = user.objectID.toInt()!
        
            self.user.name = user.name
            self.user.email = user.objectForKey("email") as String
            self.user.facebookId = userFBID
            self.user.gender = user.objectForKey("gender") as NSString
            if let birthday: AnyObject = user.objectForKey("birthday") {
                self.user.birthdate = Util.dateFromString("MM/dd/yyyy", date: birthday as String)
            }
        
            api.HTTPGet("/user/facebook/\(user.objectID)")
        }
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
            //let stringId:NSString = results["id"] as NSNumber
            self.user.id = results["id"] as NSNumber
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(self.user.dictionaryFromUser(), forKey: "loggedUser")
            defaults.synchronize()
            
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as UITabBarController
            self.navigationController?.pushViewController(homeViewController, animated: false)
        }
    }
}


