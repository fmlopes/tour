//
//  CommentCell.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/6/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class PostCell:UITableViewCell, APIProtocol {
    
    var post:Post = Post()
    var userHasLiked = false
    var userHasCommented = false
    var userIsGoingThere = false
    lazy var api:API = API(delegate: self)
    
    
    
    @IBOutlet weak var likeButton: UIButton!
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
        if userHasLiked {
            likeButton.setImage(UIImage(named: "like_inactive"), forState: UIControlState.Normal)
            userHasLiked = false
        } else {
            api.callback = didReceiveLikeResults
            api.HTTPPostJSON("/post/like", jsonObj: self.post.likeDictionaryFromObject())
            likeButton.setImage(UIImage(named: "like_active"), forState: UIControlState.Normal)
            userHasLiked = true
        }
        
    }
    
    @IBAction func imGoingThere(sender: AnyObject) {
        var button:UIButton = sender as UIButton
        
        if userIsGoingThere {
            button.setImage(UIImage(named: "imgoing_inactive"), forState: UIControlState.Normal)
            userIsGoingThere = false
        } else {
            api.callback = didReceiveImGoingResults
            //api.HTTPPostJSON("/post/like", jsonObj: self.post.likeDictionaryFromObject())
            button.setImage(UIImage(named: "imgoing_active"), forState: UIControlState.Normal)
            userIsGoingThere = true
        }
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        
    }
    
    func didReceiveLikeResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            likeButton.setImage(UIImage(named: "like_active"), forState: UIControlState.Normal)
            userHasLiked = true
        }
    }
    
    func didReceiveImGoingResults(results: NSDictionary) {
        if (results["statusCode"] as String == MessageCode.Success.rawValue) {
            likeButton.setImage(UIImage(named: "imgoing_active"), forState: UIControlState.Normal)
            userIsGoingThere = true
        }
    }
}