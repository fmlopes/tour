//
//  CommentCell.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/6/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class PostCell:UITableViewCell {
    
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UIButton!
    @IBOutlet weak var postBackgroundImage: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postCommentsImage: UIImageView!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var postLikesImage: UIImageView!
    @IBOutlet weak var postLikesLabel: UILabel!
    @IBOutlet weak var postImGoingImage: UIImageView!
    @IBOutlet weak var postImGoingLabel: UILabel!
    @IBOutlet weak var postImGoingCountUser: UILabel!
}