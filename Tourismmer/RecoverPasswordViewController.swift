//
//  RecoverPasswordViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 09/11/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class RecoverPasswordViewController:UIViewController, APIProtocol {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    lazy var api:API = API(delegate: self)
    
    @IBAction func send(sender: AnyObject) {
        let url = "/passRecover/\(emailTextField.text)"
        
        api.HTTPGet(url)
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)

        if (results["statusCode"] as NSString == MessageCode.Success.rawValue) {
            
            alert.title = "Recuperação de senha"
            alert.message = "Email enviado com sucesso"
        
        } else {
            alert.title = "Erro"
            alert.message = "Erro ao enviar email"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alert, animated: false, completion: nil)
    }
}