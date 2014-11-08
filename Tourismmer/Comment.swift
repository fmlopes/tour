//
//  Comment.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/5/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class Comment:NSObject {
    
    var text:NSString
    var author:User
    
    init(user:User) {
        self.text = ""
        self.author = user
    }
}