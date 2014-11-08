//
//  Group.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 8/5/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class Group {
    var users = [User]()
    var location:Location
    var date:NSDate
    var type:TripType?
    var imgPath:NSString
    
    init(users:[User], location:Location, date:NSDate, type:TripType, imgPath:NSString) {
        self.users = users
        self.location = location
        self.date = date
        self.type = type
        self.imgPath = imgPath
    }
    
    init() {
        self.users = [User]()
        self.location = Location(name: "", lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
        self.date = NSDate()
        self.type = TripType.Business
        self.imgPath = ""
    }
}