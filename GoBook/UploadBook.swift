//
//  UploadBook.swift
//  GoBook
//
//  Created by Grandre on 16/4/7.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class UploadBook: NSObject {
  
    static func uploadBookInBackground(dict:NSDictionary,object:AVObject){
        
        object["BookName"]    = dict["BookName"]
        object["BookEditor"]  = dict["BookEditor"]
        object["title"]       = dict["title"]
        object["score"]       = dict["score"]
        object["type"]        = dict["type"]
        object["detailType"]  = dict["detailType"]
        object["description"] = dict["description"]
        object["user"]        = AVUser.currentUser()
        
        let image = dict["BookCover"] as! UIImage
//        let coverFile = AVFile(data: UIImagePNGRepresentation(image))
        let coverFile = AVFile(data: UIImageJPEGRepresentation(image, 0.1))
        coverFile.saveInBackgroundWithBlock { (success, error ) -> Void in
            if success{
                object["cover"] = coverFile
                object.saveInBackgroundWithBlock({ (success, error ) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("uploadBookNotification", object: self, userInfo: ["success":"finish"])
                    if success{
                        NSNotificationCenter.defaultCenter().postNotificationName("uploadBookNotification", object: self, userInfo: ["success":"true"])
                    }else{
                        NSNotificationCenter.defaultCenter().postNotificationName("uploadBookNotification", object: self, userInfo: ["success":"false"])
                    }
                })
            }
            else{
                 NSNotificationCenter.defaultCenter().postNotificationName("uploadBookNotification", object: self, userInfo: ["success":"false"])
                }
    
        
        }
    }
}