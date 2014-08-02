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
    var domainUrl:NSString = "http://tourismmer.com.br"
    var delegate:APIProtocol
    
    init(delegate:APIProtocol){
        self.delegate = delegate
    }
    
    func get(path:NSString) {
        let url: NSURL = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err?) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult["results"] as NSArray
            self.delegate.didReceiveAPIResults(jsonResult)
            })
        task.resume()
    }
}