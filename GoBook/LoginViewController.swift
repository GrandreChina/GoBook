//
//  LoginViewController.swift
//  GoBook
//
//  Created by Grandre on 16/4/6.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.username.resignFirstResponder()
        self.password.resignFirstResponder()
    }
    @IBAction func login(sender: AnyObject) {
        AVUser.logInWithUsernameInBackground(self.username.text, password: self.password.text) { (user, error ) -> Void in
            if error == nil {
//
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }else{
                if error.code == 210{
                    ProgressHUD.showError("用户名或密码错误")
                }else if error.code == 211 {
                    ProgressHUD.showError("不存在该用户")
                }else if error.code == 216 {
                    ProgressHUD.showError("未验证邮箱")
                }else if error.code == 1{
                    ProgressHUD.showError("操作频繁")
                }else{
                    ProgressHUD.showError("登录失败")
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    
    func keyboardWillHideNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.topLayout.constant = 8
            self.view.layoutIfNeeded()
        }

        
    }
    func keyboardWillShowNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.topLayout.constant = -150
            self.view.layoutIfNeeded()
        }
       
    }
    

}
