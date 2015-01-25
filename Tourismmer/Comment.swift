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
    var post:Post
    
    init(user:User) {
        
        self.text = ""
        self.author = user
        self.post = Post()
        
        super.init()
    }
    
    override init() {
        self.text = ""
        self.author = User()
        self.post = Post()
    }
    
    func dictionaryFromObject() -> Dictionary<NSString, AnyObject> {
        var userDictionary:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        userDictionary.updateValue(self.author.id, forKey: "id")
        
        var postDictionary:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        postDictionary.updateValue(self.post.id, forKey: "id")
        
        var array: Dictionary<NSString, AnyObject> = [
            "description": self.text,
            "author": userDictionary,
            "post": postDictionary
        ]
        return array
    }
}