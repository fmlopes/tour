//
//  FacebookUtil.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 11/07/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class FacebookUtil {
    class func getProfilePathURL(facebookID:NSNumber) -> String {
        return "/\(facebookID)/picture?redirect=false"
    }
}