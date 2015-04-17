//
//  MenuController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 1/27/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class MenuController:UITabBarController {
    
    @IBOutlet weak var homeTabBar: UITabBar!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBar.selectedImageTintColor = UIColor.blackColor()
    }
    
    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject?) -> UIViewController? {
        var resultVC = self.selectedViewController?.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        return resultVC
    }
}