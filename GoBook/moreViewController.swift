//
//  moreViewController.swift
//  GoBook
//
//  Created by Grandre on 16/3/23.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class moreViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var tableView:UITableView?
    var userTouXiang:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor                             = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = MAIN_RED

       
//        if let touXiang = AVUser.currentUser()["touXiangFile"] as? AVFile{
//            print("--------0-------")
//            touXiang.getDataInBackgroundWithBlock({ (data, error) in
//            print(NSThread.currentThread())
//                if error == nil{
//                self.userTouXiang = UIImageView(image: UIImage(data: data))
//                }
//            })
//        }
    }
    func injected(){
        self.tableView                                        = UITableView(frame: self.view.frame, style: .Grouped)
        self.tableView?.delegate                              = self
        self.tableView?.dataSource                            = self
        self.tableView?.registerClass( UITableViewCell.classForCoder(),forCellReuseIdentifier: "cell")
        self.tableView?.registerClass( userImage_NameCell.classForCoder(),forCellReuseIdentifier: "usercell")
        self.tableView?.tableFooterView                       = UIView()
        self.tableView?.backgroundColor                       = UIColor ( red: 0.9396, green: 0.939, blue: 0.7715, alpha: 1.0 )
        self.view.addSubview(self.tableView!)
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 1
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        NSLog("----GR----height")
        let cellPosition = (row:indexPath.row,section:indexPath.section)
        switch cellPosition {
        case (0,0):
            return 90
        case (0,2):
            return 40
        default:
            return 45
        }
        
    }
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        let cellPosition = (row:indexPath.row,section:indexPath.section)
        /**
         *  @author 革码者, 16-05-27 09:05:51
         *
         *  (0,0)即是第一个cell，这个cell使用自定义的userImage_NameCell类
         */
        switch cellPosition {
        case (0,0):
            
            cell = self.tableView?.dequeueReusableCellWithIdentifier("usercell", forIndexPath: indexPath) as! userImage_NameCell
        
        default:
            cell = (self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath))! as UITableViewCell
            for subView in cell.contentView.subviews{
                subView.removeFromSuperview()
            }
        }
        if cellPosition != (0,2){
            cell.accessoryType = .DisclosureIndicator
        }
//应该这样获取cell，这时候cell的frame的height才是heightForRowAtIndexPath里面设置的。
//        if indexPath.row == 0 && indexPath.section == 0{
//            cell = self.tableView?.dequeueReusableCellWithIdentifier("usercell", forIndexPath: indexPath) as! userImage_NameCell
//        }else{
//            cell = (self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath))! as UITableViewCell
//        }
//
/// 下面这句这样获取的cell，cell的frame并不是heightforrow里面设置的。
//        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")

        switch cellPosition {
            case (0,0):
                break
            case (0,1):
                cell.imageView?.image = UIImage(named: "ff_IconShowAlbum")
            case (1,1):
                cell.imageView?.image = UIImage(named: "MoreMyFavorites")
            case (2,1):
                cell.imageView?.image = UIImage(named: "MoreMyBankCard")
            case (3,1):
                cell.imageView?.image = UIImage(named: "MoreSetting")
                break
            case (0,2):
                let logoutButton = UIButton(frame: CGRectMake(10,5,self.view.width-20,cell.frame.height-10))
                logoutButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                logoutButton.setTitle("退出", forState: .Normal)
                logoutButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                logoutButton.addTarget(self, action: #selector(self.logoutBtnTapped), forControlEvents: UIControlEvents.TouchUpInside)
                cell.addSubview(logoutButton)
            default:
                break
        }
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
       
        let cellPosition = (row:indexPath.row,section:indexPath.section)
        switch cellPosition {
        case (0,0):
            GeneralFactory.readImageFile(  (cell  as! userImage_NameCell).logoImageView!)
//            if let touXiang = AVUser.currentUser()["touXiangFile"] as? AVFile{
//                print("--------1-------")
//
//                 (cell  as! userImage_NameCell).logoImageView?.sd_setImageWithURL(NSURL(string:touXiang.url), placeholderImage: UIImage(named: "Action_Moments"), completed: { (image, error,type, url) in
//                    self.userTouXiang = UIImageView(image: image)
//                    print(self.userTouXiang)
//                 })
//                
//                
//            }else{
//                print("--------2-------")
//                 (cell  as! userImage_NameCell).logoImageView?.image = UIImage(named: "Avatar")
//                self.userTouXiang = UIImageView(image: UIImage(named: "Avatar"))
//            }

       
        default:
           break
        }

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        let cellPosition = (row:indexPath.row,section:indexPath.section)
        switch cellPosition {
        case (0,0):
            let personInfoVC = personInfoViewController()
            personInfoVC.userTouXiang = self.userTouXiang
            personInfoVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(personInfoVC, animated: true)
        case (0,1):
            break
        default:
            break
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:
            return "真的要离开了吗？"
        default:
            return nil
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 50
        default:
            return 10
        }
    }
    
    func logoutBtnTapped(){
        
        let alertVC = UIAlertController(title: "客官", message: "真的要注销退出用户吗", preferredStyle: .Alert)
        
        let alertAc1 = UIAlertAction(title: "确定", style: .Default) { (_) in
            AVUser.logOut()
            if AVUser.currentUser() == nil{
                let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                let loginVC = storyBoard.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(loginVC, animated: true, completion: { () -> Void in
                    let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
                    rootVC.selectedIndex = 0
                })
            }
        }

        let alertAc2 = UIAlertAction(title: "取消", style: .Default) { (_) in
            self.dismissViewControllerAnimated(true, completion: {
                
            })
        }
        alertVC.addAction(alertAc2)
        alertVC.addAction(alertAc1)
        self.presentViewController(alertVC, animated: true) { 
            
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        
        self.tableView?.reloadData()
        
    }
    override func viewWillDisappear(animated: Bool) {
        
    }
    
}
