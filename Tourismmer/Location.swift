//
//  Location.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 8/5/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class Location {
    var name:NSString
    var lat:NSDecimalNumber
    var long:NSDecimalNumber

    init(name:NSString, lat:NSDecimalNumber, long:NSDecimalNumber) {
        self.name = name
        self.lat = lat
        self.long = long
    }
}