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
    var apiURL:String = "http://54.94.141.250:8080/tourismmer/resources"
    var delegate:APIProtocol
    
    init(delegate:APIProtocol){
        self.delegate = delegate
    }
    
    func get(path:NSString) {
        let fullPath:NSString = apiURL + path
        let url: NSURL = NSURL(string: fullPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if((error) != nil) {
                // If there is an error in the web request, print it to the console
                println(error.description)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if((err?) != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            //let results: NSArray = jsonResult["results"] as NSArray
            self.delegate.didReceiveAPIResults(jsonResult)
            })
        task.resume()
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
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            if((err?) != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.delegate.didReceiveAPIResults(jsonResult)
            })
        })
        task.resume()
    }
    
    func HTTPGet(url: String) -> Void {
        let fullPath:String = apiURL + url
        var request = NSMutableURLRequest(URL: NSURL(string: fullPath)!)
        HTTPsendRequest(request)
    }
    
    func HTTPPostJSON(url: String, jsonObj: Dictionary<NSString, NSString>) -> Void {
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

