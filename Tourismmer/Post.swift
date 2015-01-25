//
//  Post.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/5/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class Post:NSObject {
    
    var id: NSNumber
    var text:NSString
    var imagePath:NSString
    var likeCount:NSInteger
    var commentCount:NSInteger
    var imGoingCount:NSInteger
    var author:User
    var comments:[Comment]
    var postType:PostType
    
    init(id:NSNumber, text:NSString, imagePath:NSString, likeCount:NSInteger, commentCount:NSInteger, imGoingCount: NSInteger, user:User, comments:[Comment], postType:PostType) {
        self.id = id
        self.text = text
        self.imagePath = imagePath
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.imGoingCount = imGoingCount
        self.author = user
        self.comments = comments
        self.postType = postType
    }
    
    override init() {
        self.id = 0
        self.text = ""
        self.imagePath = ""
        self.likeCount = 0
        self.commentCount = 0
        self.imGoingCount = 0
        self.author = User()
        self.comments = [Comment]()
        self.postType = PostType.Recomendation
        
        super.init()
    }
}