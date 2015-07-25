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
    var delegate:APIProtocol
    
    init(delegate:APIProtocol){
        self.delegate = delegate
    }
    
    func HTTPsendRequest(request: NSMutableURLRequest) -> Void {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if((error) != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as! NSDictionary
            if((err) != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if ((self.callback) != nil) {
                    self.callback(jsonResult)
                } else {
                    self.delegate.didReceiveAPIResults(jsonResult)
                }
            })
        })
        task.resume()
    }
    
    func HTTPGet(url: String) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let fullPath:String = apiURL + url
        var request = NSMutableURLRequest(URL: NSURL(string: fullPath)!)
        HTTPsendRequest(request)
    }
    
    func HTTPPostJSON(url: String, jsonObj: Dictionary<NSString, AnyObject>) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let fullPath:String = apiURL + url
        var request = NSMutableURLRequest(URL: NSURL(string: fullPath)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var err: NSError?
        
        let jsonString = NSJSONSerialization.dataWithJSONObject(jsonObj, options: nil, error: &err)
        
        request.HTTPBody = jsonString
        println(NSString(data: jsonString!, encoding: NSUTF8StringEncoding))
        HTTPsendRequest(request)
    }
}

