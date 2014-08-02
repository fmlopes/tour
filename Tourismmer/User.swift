//
//  User.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 7/31/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
class User {
    var id:Int64
    var name:NSString
    var city:NSString
    var birthdate:NSDate
    var email:NSString
    var pass:NSString
    var gender:NSString
    var relationshipStatus:NSString
    var facebookId:Int64
    
    init(id:Int64, name:NSString, city:NSString, birthdate:NSDate, email:NSString, pass:NSString, gender:NSString, relationshipStatus:NSString, facebookId:Int64) {
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
}