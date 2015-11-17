//
//  LoginViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 7/28/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, APIProtocol {
    
    var user:User = User()
    
    //@IBOutlet weak var recoverPassButton: UIButton!
    //@IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var fbLoginView: FBSDKLoginButton!
    //@IBOutlet weak var emailTextField: UITextField!
    //@IBOutlet weak var passTextField: UITextField!
    //@IBOutlet weak var loginButton: UIButton!
    lazy var api:API = API(delegate: self)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        setLayout()
        let fbLoginManager = FBSDKLoginManager();
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.SystemAccount;
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        if let u = Util.getUserFromDefaults()
        {
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
            self.navigationController?.pushViewController(homeViewController, animated: false)
            
        } else if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("User already authorized app")
            returnUserData()
            
        } else {
            
//            self.emailTextField.backgroundColor = UIColor.whiteColor()
//            self.emailTextField.alpha = 0.3
//            
//            self.passTextField.backgroundColor = UIColor.whiteColor()
//            self.passTextField.alpha = 0.3
            
//            emailTextField.hidden = false
//            passTextField.hidden = false
//            loginButton.hidden = false
            fbLoginView.hidden = false
            //registerButton.hidden = false
            //recoverPassButton.hidden = false
        }
    }
    
    func setLayout() {
//        emailTextField.hidden = true
//        passTextField.hidden = true
//        loginButton.hidden = true
        fbLoginView.hidden = true
        //registerButton.hidden = true
//        recoverPassButton.hidden = true
        
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func login(sender: AnyObject) {
//        if (isValidForm()) {
//            let encodedEmail:String = emailTextField.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//            let encodedPass:String = passTextField.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//            
//            self.user.loginType = "EMAIL"
//            
//            api.HTTPGet("/user/\(encodedEmail)/\(encodedPass)")
//            
//        } else {
//            let alert = UIAlertController(title: "Erro", message: "Os campos Email e Senha são obrigatórios.", preferredStyle: UIAlertControllerStyle.Alert)
//            
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
//                handler: nil))
//            
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
//    }
    
//    func isValidForm() -> Bool {
//        if (emailTextField.text.isEmpty || passTextField.text.isEmpty) {
//            return false
//        }
//        
//        return true
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
//        self.emailTextField.resignFirstResponder()
//        self.passTextField.resignFirstResponder()
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            print("Cancelled")
        } else {
            self.returnUserData()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func didReceiveAPIResults(results: NSDictionary)  {
        print(results)
        if (results["statusCode"] as! String == MessageCode.RecordNotFound.rawValue) {
            
            api.HTTPPostJSON("/user", jsonObj: self.user.dictionaryFromUserDTO())
        } else if (results["statusCode"] as! String == MessageCode.UserNotRegistered.rawValue) {
            api.HTTPPostJSON("/user", jsonObj: self.user.dictionaryFromUserDTO())
        } else if (results["statusCode"] as! String == MessageCode.UserOrPassInvalid.rawValue) {
            let alert = UIAlertController(title: "Erro", message: "Email ou senha inválidos.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                handler: nil))
            
            self.presentViewController(alert, animated: false, completion: nil)
        } else {
            self.user.id = results["id"] as! NSNumber
            let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(self.user.dictionaryFromUserDefaults(), forKey: "loggedUser")
            defaults.synchronize()
            
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                if Util.getUserFromDefaults() == nil
                {
                    self.user.name = result.valueForKey("name") as! String
                    self.user.email = result.valueForKey("email") as! String
                    let facebookId:String = result.valueForKey("id") as! String
                    self.user.facebookId = strtoll(facebookId, nil, 10)
                    self.user.gender = result.valueForKey("gender") as! String
                    if let birthday: AnyObject = result.valueForKey("birthday") as? String {
                        self.user.birthdate = Util.dateFromString("MM/dd/yyyy", date: birthday as! String)
                    }
                    self.user.loginType = "FB"
                    
                    self.api.callback = nil
                    self.api.HTTPGet("/user/facebook/\(self.user.facebookId)")
                }
            }
        })
    }
}


