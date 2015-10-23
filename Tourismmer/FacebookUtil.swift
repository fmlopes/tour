//
//  FacebookUtil.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/07/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class FacebookUtil {
    class func getProfilePathURL(facebookID:Int64) -> String {
        return "/\(facebookID)/picture?height=100&width=100"
    }
    
    class func getProfilePathURL(facebookID:Int64, size:String) -> String {
        return "/\(facebookID)/picture?type=\(size)"
    }
    
    class func getProfilePathURL(facebookID:Int64, width: Int, heigth: Int) -> String {
        return "/\(facebookID)/picture?height=\(heigth)&width=\(width)"
    }
}