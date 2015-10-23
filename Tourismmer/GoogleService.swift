//
//  GoogleService.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 12/12/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

protocol GoogleServiceProtocol {
    func didReceiveGoogleResults(results: NSDictionary)
}

class GoogleService:APIProtocol {
    var googleURL:String = "https://maps.googleapis.com"
    var delegate:GoogleServiceProtocol
    lazy var api:API = API(delegate: self)
    
    init(delegate:GoogleServiceProtocol){
        self.delegate = delegate
    }
    
    func HTTPGet(url: String) -> Void {
        let fullPath:String = googleURL + url
        let request = NSMutableURLRequest(URL: NSURL(string: fullPath.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        api.HTTPsendRequest(request)
    }
    
    func didReceiveAPIResults(result: NSDictionary) -> Void {
        self.delegate.didReceiveGoogleResults(result)
    }
}
