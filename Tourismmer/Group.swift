//
//  Group.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 8/5/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class Group {
    var id:NSNumber
    var users = [User]()
    var owner = User()
    var location:Location
    var date:NSDate
    var type:TripType?
    var imgPath:NSString
    
    init(users:[User], user:User, location:String, date:NSDate, type:TripType, imgPath:NSString, id: NSNumber) {
        self.users = users
        self.owner = user
        self.location = Location(name: location, lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
        self.date = date
        self.type = type
        self.imgPath = imgPath
        self.id = id
    }
    
    init() {
        self.users = [User]()
        self.location = Location(name: "", lat: NSDecimalNumber.zero(), long: NSDecimalNumber.zero())
        self.date = NSDate()
        self.type = TripType.Business
        self.imgPath = ""
        self.id = 0
    }
    
    func dictionaryFromGroup() -> Dictionary<String, AnyObject> {
        var purposeDictionary:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        purposeDictionary.updateValue(self.type!.id(), forKey: "id")
        
        var userDictionary:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        userDictionary.updateValue(self.owner.id, forKey: "id")
        
        var array: Dictionary<String, AnyObject> = [
            "destination": location.name,
            "date": Util.stringFromDate("dd-MM-yyyy", date: date),
            "purpose": purposeDictionary,
            "owner": userDictionary
        ]
        return array
    }
}