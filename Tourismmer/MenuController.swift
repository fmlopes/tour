//
//  MenuController.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 1/27/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class MenuController:UITabBarController {
    
    override func viewDidLoad() {
        for item in self.viewControllers as [UIViewController] {
            //item.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        }
    }
}