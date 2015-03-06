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
    var group:Group
    var date:NSDate
    
    init(id:NSNumber, text:NSString, imagePath:NSString, likeCount:NSInteger, commentCount:NSInteger, imGoingCount: NSInteger, user:User, comments:[Comment], postType:PostType, group:Group, date:NSDate) {
        self.id = id
        self.text = text
        self.imagePath = imagePath
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.imGoingCount = imGoingCount
        self.author = user
        self.comments = comments
        self.postType = postType
        self.group = group
        self.date = date
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
        self.group = Group()
        self.date = NSDate()
        
        super.init()
    }
    
    func dictionaryFromObject() -> Dictionary<String, AnyObject> {
        var groupDictionary:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        groupDictionary.updateValue(self.group.id, forKey: "id")
        
        var authorDictionary:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        authorDictionary.updateValue(self.author.id, forKey: "id")
        
        var postTypeDictionary:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        postTypeDictionary.updateValue(self.postType.id(), forKey: "id")
        
        var array: Dictionary<String, AnyObject> = [
            "description": text,
            "author": authorDictionary,
            "group": groupDictionary,
            "typePost": postTypeDictionary
            //"date": Util.stringFromDate("dd-MM-yyyy", date: self.date)
        ]
        return array
    }
    
    func likeDictionaryFromObject() -> Dictionary<String, AnyObject> {
        var array: Dictionary<String, AnyObject> = [
            "idUser": self.author.id,
            "idPost": self.id
        ]
        return array
    }
}