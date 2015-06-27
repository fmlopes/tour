//
//  Cell.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 10/6/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class Cell:UITableViewCell {
    
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postGoal: UILabel!
    
    var id:NSNumber = 0
    
    func setCell(group:Group) -> Void {
        self.postText.text = group.location.name.uppercaseString
        if (group.type  != nil){
            self.postGoal.text = group.type?.rawValue.uppercaseString
        }
        self.postImage.image = UIImage(named: "image_placeholder")
        self.postImage.hidden = false
        self.postDate.text = Util.stringFromDate("MM/yy", date: group.date)
        self.id = group.id
        
        if group.imgPath != "" {
            var imgURL:NSURL = NSURL(string:group.imgPath as String)!
            
            let request:NSURLRequest = NSURLRequest(URL: imgURL)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
                if !(error != nil) {
                    
                    self.postImage.image = UIImage(data: data)
                    
                } else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        } else {
            self.postImage.hidden = true
        }
    }
}
