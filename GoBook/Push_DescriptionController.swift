//
//  Push_DescriptionController.swift
//  GoBook
//
//  Created by Grandre on 16/3/27.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit
typealias Push_DescriptionControllerCallBack = (description:String)->Void

class Push_DescriptionController: UIViewController {

    var textView:JVFloatLabeledTextView?
    var callBack:Push_DescriptionControllerCallBack?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.textView = JVFloatLabeledTextView(frame: CGRectMake(8,58,SCREEN_WIDTH-16 ,SCREEN_HEIGHT - 58 - 8))
        self.view.addSubview(self.textView!)
        self.textView?.placeholder = "      你可以在这里撰写详细的评价、吐槽、介绍～～"
        self.textView?.font = UIFont(name: MY_FONT, size: 17)
        self.view.tintColor = UIColor.redColor()//placeholder的颜色
        self.textView?.becomeFirstResponder()
        
        XKeyBoard.registerKeyBoardShow(self)//其实是对键盘出现和消失的通知的封装。下面必须实现对应的方法。
        XKeyBoard.registerKeyBoardHide(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sure(){
        self.callBack!(description: (self.textView?.text)!)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    func close(){
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

    func keyboardWillHideNotification(notification:NSNotification){
        self.textView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    func keyboardWillShowNotification(notification:NSNotification){
        let rect = XKeyBoard.returnKeyBoardWindow(notification)
        self.textView?.contentInset = UIEdgeInsetsMake(0, 0, rect.size.height, 0)
    }
}
