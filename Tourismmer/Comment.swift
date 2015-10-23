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
    var date:NSDate
    
    init(user:User) {
        
        self.text = ""
        self.author = user
        self.post = Post()
        self.date = NSDate()
        
        super.init()
    }
    
    override init() {
        self.text = ""
        self.author = User()
        self.post = Post()
        self.date = NSDate()
    }
    
    func dictionaryFromObject() -> Dictionary<NSString, AnyObject> {
        var userDictionary:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        userDictionary.updateValue(self.author.id, forKey: "id")
        
        var postDictionary:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        postDictionary.updateValue(self.post.id, forKey: "id")
        
        let array: Dictionary<NSString, AnyObject> = [
            "description": self.text,
            "author": userDictionary,
            "post": postDictionary
            //"date": Util.stringFromDate("yyyy-MM-dd", date: self.date)
        ]
        return array
    }
}