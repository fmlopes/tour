//
//  ProfilePostCell.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/6/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class ProfilePostCell:UITableViewCell, APIProtocol {
    
    var post:Post = Post()
    var userHasLiked = false
    var userHasCommented = false
    var userIsGoingThere = false
    lazy var api:API = API(delegate: self)
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postBackgroundImage: UIImageView!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var postLikesLabel: UILabel!
    
    func setCell() -> Void {
        postBackgroundImage.image = UIImage(named: "image_placeholder")
        postTextLabel!.text = post.text as String
        postCommentLabel!.text = String(post.commentCount)
        postLikesLabel!.text = String(post.likeCount)
        
        userHasLiked = post.userHasLiked
        userHasCommented = post.userHasCommented
        userIsGoingThere = post.userIsGoing
        
        if (post.userHasLiked) {
            likeButton.setImage(UIImage(named: "like_active"), forState: UIControlState.Normal)
        }
        
        if (post.userHasCommented) {
            commentButton.setImage(UIImage(named: "comment_active"), forState: UIControlState.Normal)
        }
        
        if post.imagePath != "" {
            if post.imageAlreadyLoaded {
                postBackgroundImage.image = post.image
            } else {
                Util.setProfilePostCellImageByURL(post.imagePath as String, callback: postCellImageCallback, postCell: self, post: post)
            }
            setLayout(true)
        } else {
            setLayout(false)
        }
    }
    
    func setLayout(imageDoesExist:Bool) {
        
        var height:CGFloat = 0
        if imageDoesExist {
            postBackgroundImage.hidden = false
            height = 380
        } else {
            height = 90
            postBackgroundImage.hidden = true
        }
        likeButton.layer.frame.origin.y = height
        postLikesLabel.layer.frame.origin.y = height + 15
        commentButton.layer.frame.origin.y = height
        postCommentLabel.layer.frame.origin.y = height + 15
    }
    
    func postCellImageCallback(image:UIImage, postCell:ProfilePostCell, post:Post) -> Void {
        postCell.postBackgroundImage.image = image
        post.image = image
        post.imageAlreadyLoaded = true
    }
    
    @IBAction func comment(sender: AnyObject) {
        
    }
    
    @IBAction func like(sender: AnyObject) {
        api.callback = didReceiveLikeResults
        api.HTTPPostJSON("/post/like", jsonObj: self.post.likeDictionaryFromObject())
        if userHasLiked {
            likeButton.setImage(UIImage(named: "like_inactive"), forState: UIControlState.Normal)
            userHasLiked = false
        } else {
            likeButton.setImage(UIImage(named: "like_active"), forState: UIControlState.Normal)
            userHasLiked = true
        }
        
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        
    }
    
    func didReceiveLikeResults(results: NSDictionary) {
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            likeButton.setImage(UIImage(named: "like_active"), forState: UIControlState.Normal)
            userHasLiked = true
        } else if (results["statusCode"] as! String == MessageCode.SuccessUndo.rawValue) {
            likeButton.setImage(UIImage(named: "like_inactive"), forState: UIControlState.Normal)
            userHasLiked = false
        }
    }
}