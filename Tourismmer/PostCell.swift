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
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var imGoingButton: UIButton!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var postLikesLabel: UILabel!
    @IBOutlet weak var postImGoingCountUser: UILabel!
    @IBOutlet weak var footerView: UIView?
    
    func setCell() -> Void {
        
        postTextLabel!.text = post.text as String
        postCommentLabel!.text = String(post.commentCount)
        postImGoingCountUser!.text = String(post.imGoingCount)
        postLikesLabel!.text = String(post.likeCount)
        userNameLabel!.text = String(post.author.name)
        
        userHasLiked = post.userHasLiked
        userHasCommented = post.userHasCommented
        userIsGoingThere = post.userIsGoing
        
        if (post.userHasLiked) {
            likeButton.setImage(UIImage(named: "like_active"), forState: UIControlState.Normal)
        }
        
        if (post.userHasCommented) {
            commentButton.setImage(UIImage(named: "comment_active"), forState: UIControlState.Normal)
        }
        
        if (post.userIsGoing) {
            imGoingButton.setImage(UIImage(named: "imgoing_active"), forState: UIControlState.Normal)
        }
        
        setLayout()
        
//        if post.imagePath != "" {
//            if post.imageAlreadyLoaded {
//                postBackgroundImage.image = post.image
//            } else {
//                Util.setPostCellImageByURL(post.imagePath as String, callback: postCellImageCallback, postCell: self, post: post)
//            }
//            setLayout(true)
//        } else {
//            setLayout(false)
//        }
        
        FacebookService.setFacebookPhotoInPostCell(post.author.profilePicturePath, cell: self)
        
    }
    
    func setLayout() {
        
        // Shadow for post image
//        shadowView.layer.shadowColor = UIColor.darkGrayColor().CGColor
//        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 12.0).CGPath
//        shadowView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        shadowView.layer.shadowOpacity = 1.0
//        shadowView.layer.shadowRadius = 2
//        shadowView.layer.masksToBounds = true
//        shadowView.clipsToBounds = false
        
        // Circle Profile Photo
        userPhoto!.layer.masksToBounds = false
        userPhoto!.layer.cornerRadius = userPhoto!.frame.height/2
        userPhoto!.clipsToBounds = true
        
        self.footerView?.backgroundColor = UIColor(white: 1, alpha: 0)
        
        postTextLabel.numberOfLines = 0
    }
    
//    func postCellImageCallback(image:UIImage, postCell:PostCell, post:Post) -> Void {
//        postCell.postBackgroundImage.image = image
//        post.image = image
//        post.imageAlreadyLoaded = true
//    }
    
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
    
    @IBAction func imGoingThere(sender: AnyObject) {
        api.callback = didReceiveImGoingResults
        api.HTTPPostJSON("/post/userGo", jsonObj: self.post.likeDictionaryFromObject())
        
        if userIsGoingThere {
            imGoingButton.setImage(UIImage(named: "imgoing_inactive"), forState: UIControlState.Normal)
            userIsGoingThere = false
        } else {
            
            imGoingButton.setImage(UIImage(named: "imgoing_active"), forState: UIControlState.Normal)
            userIsGoingThere = true
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
    
    func didReceiveImGoingResults(results: NSDictionary) {
        if (results["statusCode"] as! String == MessageCode.Success.rawValue) {
            imGoingButton.setImage(UIImage(named: "imgoing_active"), forState: UIControlState.Normal)
            userIsGoingThere = true
        } else if (results["statusCode"] as! String == MessageCode.SuccessUndo.rawValue) {
            imGoingButton.setImage(UIImage(named: "imgoing_inactive"), forState: UIControlState.Normal)
            userIsGoingThere = false
        }
    }
}