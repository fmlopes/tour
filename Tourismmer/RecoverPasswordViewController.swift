//
//  RecoverPasswordViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 09/11/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class RecoverPasswordViewController:UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func send(sender: AnyObject) {
        var alert = UIAlertController(title: "Recuperação de senha", message:
            "Email enviado com sucesso!", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alert, animated: false, completion: nil)
        
    }
}