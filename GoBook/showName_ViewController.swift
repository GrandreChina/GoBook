//
//  showName_ViewController.swift
//  GoBook
//
//  Created by Grandre on 16/5/26.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

typealias _showNameTextFieldBlock = (String)->Void
class showName_ViewController: UIViewController,UITextFieldDelegate{
    var showNameTextField:UITextField!
    var showNameString:String!
    var rightBarBtn:UIBarButtonItem!
    var showNameTextFieldBlock:_showNameTextFieldBlock?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.showNameTextField = UITextField(frame:CGRectMake(10, 80, SCREEN_WIDTH-20, 40) )
        self.showNameTextField?.placeholder = "我的昵称:"
        self.showNameTextField?.clearButtonMode = .Always
        self.showNameTextField?.borderStyle = .RoundedRect
        self.showNameTextField?.layer.borderColor = MAIN_RED.CGColor
        showNameTextField?.layer.borderWidth = 3
        showNameTextField.layer.masksToBounds = true
        showNameTextField.layer.cornerRadius = 10
        self.showNameTextField.text = self.showNameString
        
        self.view.addSubview(self.showNameTextField!)
        
        rightBarBtn = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(self.rightBtnTapped))
        self.navigationItem.setRightBarButtonItem(self.rightBarBtn, animated: true)
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.showNameTextFieldDidChange), name: UITextFieldTextDidChangeNotification, object: nil)
    }
    func showNameTextFieldDidChange() -> Void {
        print("hello")
        if self.showNameString == self.showNameTextField.text{
            self.navigationItem.rightBarButtonItem?.enabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    func rightBtnTapped(){
        print("rightBtn tapped")
        print(self.showNameTextField?.text)
        
        self.showNameTextFieldBlock!((self.showNameTextField?.text)!)
        
        let user = AVUser.currentUser()
        user["showName"] = self.showNameTextField?.text
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            if success {
                ProgressHUD.showSuccess("昵称保存成功")
                self.navigationController?.popViewControllerAnimated(true)
                
            }else{
                    ProgressHUD.showError("保存失败")
            }
        }

    }
  
    override func viewWillDisappear(animated: Bool) {
        print("showName_ViewController disappear")
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print("showName_ViewController release")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
