//
//  TermsViewController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 4/1/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class TermsViewController: UIViewController {
    
    @IBAction func cancelToSettingsViewController(segue:UIStoryboardSegue) {
        print("fwfew")
    }
    
    override func viewDidLoad() {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Medium", size: 19)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
}
