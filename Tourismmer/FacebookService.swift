//
//  FacebookService.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 1/24/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

class FacebookService:APIProtocol {
    var fbURL:String = "https://graph.facebook.com/v2.2"
    var facebookImageCallback: ((UIImage?) -> Void)!
    lazy var api:API = API(delegate: self)
    
    func setFacebookProfilePhoto(userFacebookID: Int64, facebookImageCallback: ((UIImage?) -> Void)!) -> Void {
        let fullPath:String = "https://graph.facebook.com/\(FacebookUtil.getProfilePathURL(userFacebookID))"
        
        facebookImageCallback(Util.getImageFromURL(fullPath))
    }
    
    func didReceiveAPIResults(result: NSDictionary) -> Void {
        let dataResult:NSDictionary = result["data"] as! NSDictionary
        
        facebookImageCallback(Util.getImageFromURL(dataResult["url"] as! String))
        
    }
}