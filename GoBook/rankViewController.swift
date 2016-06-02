//
//  rankViewController.swift
//  GoBook
//
//  Created by Grandre on 16/3/23.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class rankViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    if AVUser.currentUser() == nil{
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyBoard.instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(loginVC, animated: true, completion: { () -> Void in
            
        })
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
