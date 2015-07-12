//
//  User.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 7/31/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
class User:NSObject {
    var id:NSNumber
    var name:NSString
    var birthdate:NSDate
    var email:NSString
    var pass:NSString
    var gender:NSString
    var facebookId:Int64
    
    override init() {
        self.id = 0
        self.name = ""
        self.birthdate = NSDate()
        self.email = ""
        self.pass = ""
        self.gender = ""
        self.facebookId = 0
        
        super.init()
    }
    
    init(id:NSNumber, name:NSString, birthdate:NSDate, email:NSString, pass:NSString, gender:NSString, facebookId:Int64) {
        self.id = id
        self.name = name
        self.birthdate = birthdate
        self.email = email
        self.pass = pass
        self.gender = gender
        self.facebookId = facebookId
    }
    
    func dictionaryFromUser() -> Dictionary<NSString, NSString> {
        var array: Dictionary<NSString, NSString> = [
            "id": getId(),
            "name": self.name,
            "birthday": Util.stringFromDate("dd-MM-yyyy", date: self.birthdate),
            "email": self.email,
            "pass": self.pass,
            "gender": "male",
            "facebookId": getFacebookId()
        ]
        return array
    }
    
    func getId() -> String {
        if (self.id == 0) {
            return "";
        } else {
            return self.id.stringValue
        }
    }
    
    func getFacebookId() -> String {
        if (self.facebookId == 0) {
            return "";
        } else {
            return String(self.facebookId)
        }
    }
}