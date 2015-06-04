//
//  FacebookService.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 1/24/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

protocol FacebookServiceProtocol {
    func didReceiveFacebookResults(results: NSDictionary)
}

class FacebookService {
    var fbURL:String = "https://graph.facebook.com/v2.2"
    var delegate:FacebookServiceProtocol
    
    init(delegate:FacebookServiceProtocol){
        self.delegate = delegate
    }
    
    func HTTPGet(url: String) -> Void {
        let fullPath:String = fbURL + url
        var request = NSMutableURLRequest(URL: NSURL(string: fullPath.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        HTTPsendRequest(request)
    }
    
    private func HTTPsendRequest(request: NSMutableURLRequest) -> Void {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if((error) != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as! NSDictionary
            if((err) != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.delegate.didReceiveFacebookResults(jsonResult)
            })
        })
        task.resume()
    }
}