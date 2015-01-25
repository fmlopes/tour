//
//  Util.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 10/7/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

class Util {
    
    class func stringFromDate(format: String, date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }
    
    class func dateFromString(format: String, date: NSString) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.dateFromString(date)!
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