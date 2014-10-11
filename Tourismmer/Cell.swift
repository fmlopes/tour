//
//  Cell.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 10/6/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class Cell:UITableViewCell {
    
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postGoal: UILabel!
}
