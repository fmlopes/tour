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
    var city:NSString
    var birthdate:NSDate
    var email:NSString
    var pass:NSString
    var gender:NSString
    var relationshipStatus:NSString
    var facebookId:NSNumber
    
    init(id:NSNumber, name:NSString, city:NSString, birthdate:NSDate, email:NSString, pass:NSString, gender:NSString, relationshipStatus:NSString, facebookId:NSNumber) {
        self.id = id
        self.name = name
        self.city = city
        self.birthdate = birthdate
        self.email = email
        self.pass = pass
        self.gender = gender
        self.relationshipStatus = relationshipStatus
        self.facebookId = facebookId
    }
    
    func dictionaryFromUser() -> Dictionary<String, String> {
        var obj:Dictionary<String, String> = [
            "id": self.id.stringValue,
            "name": self.name,
            "city": self.city,
            "birthdate": self.birthdate.description,
            "email": self.email,
            "pass": self.pass,
            "gender": self.gender,
            "relationshipStatus": self.relationshipStatus,
            "facebookId": self.facebookId.stringValue
        ]
        
        return obj
    }
}