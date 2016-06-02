//
//  Push_TitleController.swift
//  GoBook
//
//  Created by Grandre on 16/3/27.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit
//采用闭包回调时，闭包实质上是一种类型，如果没有采用typealias，则不能直接var 变量 = (titile:String)->Void
//因为闭包只是一个函数类型。
typealias TextfieldValueCallBack = (title:String)->Void
class Push_TitleController: UIViewController {

    var TitleValueCallBack:TextfieldValueCallBack?
    var titleTextField:UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        titleTextField = UITextField(frame: CGRectMake(15,60,SCREEN_WIDTH-30,30))
        self.titleTextField?.borderStyle = .RoundedRect
        self.titleTextField?.font = UIFont(name: MY_FONT, size: 15)
        self.titleTextField?.placeholder = "书评标题"
        self.titleTextField?.becomeFirstResponder()
        self.view.addSubview(self.titleTextField!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func sure(){
        print(self.titleTextField?.text)
        self.TitleValueCallBack!(title:(self.titleTextField?.text)!)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    func close(){
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

}
