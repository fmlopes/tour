//
//  Post.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/5/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class Post:NSObject {
    
    var text:NSString
    var imagePath:NSString
    var likeCount:NSInteger
    var author:User
    var comments:[Comment]
    
    init(text:NSString, imagePath:NSString, likeCount:NSInteger, user:User, comments:[Comment]) {
        self.text = text
        self.imagePath = imagePath
        self.likeCount = likeCount
        self.author = user
        self.comments = comments
    }
}