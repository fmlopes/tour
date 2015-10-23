//
//  Util.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 10/7/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import SystemConfiguration

class Util {
    
    class func getImageFromURL(imgPath:String) -> UIImage? {
        let url = NSURL(string: imgPath as String)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        return UIImage(data: data!)
    }
    
    class func nsDataToJson(data:NSData, callback:((NSDictionary) -> Void)!) -> Void {
        do {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments, .MutableContainers]) as! NSDictionary
            
            callback(jsonResult)
        } catch {
            print("Fetch failed: \((error as NSError).localizedDescription)")
        }
    }
    
    class func hasConnectivity() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags.ConnectionAutomatic
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    class func setPostCellImageByURL(imageURL:String, callback:((UIImage, ImagePostCell, Post) -> Void)!, postCell:ImagePostCell, post:Post) -> Void {
        let request:NSURLRequest = NSURLRequest(URL: NSURL(string:imageURL)!)
        
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            // Handle incoming data like you would in synchronous request
            callback(UIImage(data: data!)!, postCell, post)
        }
    }
    
    class func getBooleanFromString(str:String) -> Bool {
        if (str == "1") {
            return true
        }
        return false
    }
    
    class func getJsonOptionalBool(results:NSDictionary, fieldName: String) -> Bool {
        var fieldValue = false
        if results.objectForKey(fieldName) != nil {
            fieldValue = results[fieldName] as! Bool
        }
        return fieldValue
    }
    
    class func getJsonOptionalDictionary(results:NSDictionary, fieldName: String) -> NSDictionary {
        var fieldValue = NSDictionary()
        if results.objectForKey(fieldName) != nil {
            fieldValue = results[fieldName] as! NSDictionary
        }
        return fieldValue
    }
    
    class func getJsonOptionalString(results:NSDictionary, fieldName: String) -> String {
        var fieldValue = ""
        if results.objectForKey(fieldName) != nil {
            fieldValue = results[fieldName] as! String
        }
        return fieldValue
    }
    
    class func getJsonOptionalInteger(results:NSDictionary, fieldName: String) -> NSInteger {
        var fieldValue = 0
        if results.objectForKey(fieldName) != nil {
            fieldValue = results[fieldName] as! NSInteger
        }
        return fieldValue
    }
    
    class func getUserFromDefaults() -> User? {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey("loggedUser") != nil {
        
            let loggedUser:Dictionary<NSString, AnyObject> = defaults.objectForKey("loggedUser") as! Dictionary<String, AnyObject>
            let stringId:NSString = loggedUser["id"] as! NSString
        
            let user:User = User()
            user.id = stringId.integerValue
            let facebookId:String = loggedUser["facebookId"] as! String
            user.facebookId = strtoll(facebookId, nil, 10)
            user.name = loggedUser["name"] as! NSString
            user.email = loggedUser["email"] as! NSString
        
            return user
        } else {
            return nil
        }
    }
    
    class func dropUserFromDefaults() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey("loggedUser") != nil {
            
            defaults.removeObjectForKey("loggedUser")
        }
    }
    
    class func stringFromDate(format: String, date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }
    
    class func dateFromString(format: String, date: NSString) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.dateFromString(date as String)!
    }
    
    class func monthNumberFromString(month: String) -> String {
        switch month {
        case "JANEIRO":
            return "01"
        case "FEVEREIRO":
            return "02"
        case "MARÇO":
            return "03"
        case "ABRIL":
            return "04"
        case "MAIO":
            return "05"
        case "JUNHO":
            return "06"
        case "JULHO":
            return "07"
        case "AGOSTO":
            return "08"
        case "SETEMBRO":
            return "09"
        case "OUTUBRO":
            return "10"
        case "NOVEMBRO":
            return "11"
        case "DEZEMBRO":
            return "12"
        default:
            return ""
        }
        
    }
}