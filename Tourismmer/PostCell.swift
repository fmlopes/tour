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
    
    var id:NSNumber = 0
    var userHasLiked = false
    var userHasCommented = false
    var userIsGoingThere = false
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postBackgroundImage: UIImageView!
    @IBOutlet weak var postCommentsImage: UIImageView!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var postLikesImage: UIImageView!
    @IBOutlet weak var postLikesLabel: UILabel!
    @IBOutlet weak var postImGoingImage: UIImageView!
    @IBOutlet weak var postImGoingLabel: UILabel!
    @IBOutlet weak var postImGoingCountUser: UILabel!
    
    @IBAction func comment(sender: AnyObject) {
        
    }
    
    @IBAction func like(sender: AnyObject) {
        var button:UIButton = sender as UIButton
        
        if userHasLiked {
            button.setImage(UIImage(named: "like_inactive"), forState: UIControlState.Normal)
            userHasLiked = false
        } else {
            button.setImage(UIImage(named: "like_active"), forState: UIControlState.Normal)
            userHasLiked = true
        }
        
    }
    
    @IBAction func imGoingThere(sender: AnyObject) {
        var button:UIButton = sender as UIButton
        
        if userIsGoingThere {
            button.setImage(UIImage(named: "imgoing_inactive"), forState: UIControlState.Normal)
            userIsGoingThere = false
        } else {
            button.setImage(UIImage(named: "imgoing_active"), forState: UIControlState.Normal)
            userIsGoingThere = true
        }
    }
}