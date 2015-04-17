//
//  CommentCell.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 12/9/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class CommentCell:UITableViewCell {
    
    @IBOutlet weak var authorPhoto: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorText: UILabel!
    
    func setLayout() {
        // Circle Profile Photo
        authorPhoto!.layer.masksToBounds = false
        authorPhoto!.layer.cornerRadius = authorPhoto!.frame.height/2
        authorPhoto!.clipsToBounds = true
    }
}