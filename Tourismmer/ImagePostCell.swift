//
//  ImagePostCell.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 7/8/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class ImagePostCell:PostCell {
    
    @IBOutlet weak var postBackgroundImage: UIImageView!
    
    func setImageCell() -> Void {
        
        if post.imageAlreadyLoaded {
            postBackgroundImage.image = post.image
        } else {
            Util.setPostCellImageByURL(post.imagePath as String, callback: postCellImageCallback, postCell: self, post: post)
        }

        super.setCell()
    }
    
    func postCellImageCallback(image:UIImage, postCell:ImagePostCell, post:Post) -> Void {
        postCell.postBackgroundImage.image = image
        post.image = image
        post.imageAlreadyLoaded = true
    }
    
    @IBAction override  func comment(sender: AnyObject) {
        super.comment(sender)
    }
}