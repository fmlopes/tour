//
//  Cell.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 10/6/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation
import UIKit

class Cell:UITableViewCell, APIProtocol {
    
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postGoal: UILabel!
    
    lazy var api:API = API(delegate: self)
    var id:NSNumber = 0
    
    func setCell(group:Group) -> Void {
        self.postText.text = group.location.name.uppercaseString
        if (group.type  != nil) {
            self.postGoal.text = group.type?.rawValue.uppercaseString
        }
        self.postImage.image = UIImage(named: "image_placeholder")
        self.postImage.hidden = false
        self.id = group.id
        
        if group.imgPath != "" {
            Util.getImageFromURL(group.imgPath as String, callback: imageCallback)
        } else {
            self.postImage.hidden = true
        }
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
    }
    
    func imageCallback(data: NSData) -> Void {
        self.postImage.image = UIImage(data: data)
    }
}
