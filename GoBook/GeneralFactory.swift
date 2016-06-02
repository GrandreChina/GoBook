//
//  GeneralFactory.swift
//  GoBook
//
//  Created by Grandre on 16/3/24.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class GeneralFactory: NSObject {
    static var fileManager = NSFileManager.defaultManager()
    static var currentUser = AVUser.currentUser()
    
    static func addTitleWithTitle(target:UIViewController,leftTitle:String = "取消",rightTitle:String = "确定"){
        let btn1 = UIButton(frame: CGRectMake(10,20,40,20))
        btn1.setTitle(leftTitle, forState: .Normal)
        btn1.setTitleColor(MAIN_RED, forState: .Normal)
        btn1.contentHorizontalAlignment = .Left
        btn1.titleLabel?.font = UIFont(name: MY_FONT, size: 18)
        btn1.tag = 1234
        target.view.addSubview(btn1)
        
        let btn2 = UIButton(frame: CGRectMake(SCREEN_WIDTH - 50,20,40,20))
        btn2.setTitle(rightTitle, forState: .Normal)
        btn2.setTitleColor(MAIN_RED, forState: .Normal)
        btn2.contentHorizontalAlignment = .Right
        btn2.titleLabel?.font = UIFont(name: MY_FONT, size: 18)
        btn2.tag = 1235
        target.view.addSubview(btn2)
        
        btn1.addTarget(target, action: Selector("close"), forControlEvents: .TouchUpInside)
        btn2.addTarget(target, action: "sure", forControlEvents: .TouchUpInside)
    }
    
    static func creatDirectory()->String{
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        
        
        let touxiangDocumentPath = documentPath + "/TouxiangImg"
        
        //withIntermediateDirectories 设置为true， 代表中间所有的路径目录如果不存在，都会创建
        do{
            
            try fileManager.createDirectoryAtPath(touxiangDocumentPath, withIntermediateDirectories: true, attributes: nil)
            
        }catch{
            print("创建目录出错")
        }
        return touxiangDocumentPath
    }
    static  func creatFile(img:UIImage){
            // 创建file第一种方式。通过写入content来创建新文件。
            let filePath = creatDirectory() + "/\(currentUser.username)"
            let imgData = UIImageJPEGRepresentation(img, 0.1)
    
            if imgData!.writeToFile(filePath, atomically: true){
                print("保存图片成功")
                print(filePath)
            }else{
                print("保存图片失败")
            }
            
    }
    static func readImageFile(imageWhichNeedToSet:UIImageView){
        
        let filePath = creatDirectory() + "/\(currentUser.username)"
        if fileManager.fileExistsAtPath(filePath){
            print("---------imageFile exist 从本地缓存获取头像-----")
            //            let image = UIImage(contentsOfFile: filePath)
            let image = UIImage(data: NSData(contentsOfFile: filePath)!)
            imageWhichNeedToSet.image = image
        }else{
            if let touXiang = currentUser["touXiangFile"] as? AVFile{
                imageWhichNeedToSet.sd_setImageWithURL(NSURL(string:touXiang.url), placeholderImage: UIImage(named: "Action_Moments"), completed: { (image, error,type, url) in
                    print("-----从云端获取头像-----")
                })
               print(touXiang)
            }else{
                print("--------从bundle获取头像-------")
                imageWhichNeedToSet.image = UIImage(named: "Avatar")
                
            }
        }
        
    }

}
