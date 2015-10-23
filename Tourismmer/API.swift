//
//  API.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 7/31/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

protocol APIProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}

class API {
    var apiURL:String = "http://luggerapp.com/resources"
    var callback: ((NSDictionary) -> Void)!
    var callbackRawResult: ((NSData) -> Void)!
    var delegate:APIProtocol
    
    init(delegate:APIProtocol){
        self.delegate = delegate
    }
    
    func HTTPsendRequest(request: NSMutableURLRequest) -> Void {
        if Util.hasConnectivity() {
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                print("Task completed")
                
                dispatch_async(dispatch_get_main_queue(), {
                    if self.callback == nil {
                        self.callback = self.delegate.didReceiveAPIResults
                    }
                    
                    Util.nsDataToJson(data!, callback: self.callback)
                })
            }).resume()
        }
    }
    
    func HTTPGet(url: String) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let fullPath:String = apiURL + url
        let request = NSMutableURLRequest(URL: NSURL(string: fullPath)!)
        
        HTTPsendRequest(request)
    }
    
    func HTTPPostJSON(url: String, jsonObj: Dictionary<NSString, AnyObject>) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let fullPath:String = apiURL + url
        let request = NSMutableURLRequest(URL: NSURL(string: fullPath)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let jsonString = try NSJSONSerialization.dataWithJSONObject(jsonObj, options: [])
        
            request.HTTPBody = jsonString
            print(NSString(data: jsonString, encoding: NSUTF8StringEncoding))
            HTTPsendRequest(request)
        } catch {
            print("Fetch failed: \((error as NSError).localizedDescription)")
        }
    }
}

