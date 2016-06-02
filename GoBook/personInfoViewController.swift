//
//  personInfoViewController.swift
//  GoBook
//
//  Created by Grandre on 16/5/26.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class personInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView?
    var showName:String!
    var userTouXiang:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "个人信息"
        
        if let showName = AVUser.currentUser()["showName"]{
            self.showName = showName as! String
        }else{
            self.showName = "请输入昵称"
        }
        
        
        self.tableView = UITableView(frame: self.view.frame, style: .Grouped)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass( UITableViewCell.classForCoder(),forCellReuseIdentifier: "cell")
        self.tableView?.registerClass( userImage_NameCell.classForCoder(),forCellReuseIdentifier: "usercell")
        self.tableView?.tableFooterView = UIView()
        self.tableView?.backgroundColor = UIColor ( red: 0.9396, green: 0.939, blue: 0.7715, alpha: 1.0 )
        self.view.addSubview(self.tableView!)

        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
  
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:
            return ""
        default:
            return nil
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 15
        default:
            return 10
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 3
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        NSLog("----GR----height")
        let cellPosition = (row:indexPath.row,section:indexPath.section)
        switch cellPosition {
        case (0,0):
            return 90
        case (_,2):
            return 40
        default:
            return 45
        }
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell:UITableViewCell!
//        
        let cellPosition = (row:indexPath.row,section:indexPath.section)
//
//        switch cellPosition {
//        case (0,0):
//            cell = self.tableView?.dequeueReusableCellWithIdentifier("usercell", forIndexPath: indexPath) as! userImage_NameCell
//        default:
//            cell = (self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath))! as UITableViewCell
//            for subView in cell.contentView.subviews{
//                subView.removeFromSuperview()
//            }
//        }
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        
        if cellPosition != (1,1){
            cell.accessoryType = .DisclosureIndicator
        }
        //应该这样获取cell，这时候cell的frame的height才是heightForRowAtIndexPath里面设置的。
        
        //  cell = self.tableView?.dequeueReusableCellWithIdentifier("usercell", forIndexPath: indexPath) as! userImage_NameCell
        /// 下面这句这样获取的cell，cell的frame并不是heightforrow里面设置的。
        //        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        
        switch cellPosition {
        case (0,0):
            cell.textLabel?.text = "头像"
            let logoImageView = UIImageView(frame: CGRectMake(SCREEN_WIDTH-80-40, 5, 80, 80))
//            logoImageView.image = self.userTouXiang?.image
            GeneralFactory.readImageFile(logoImageView)
            logoImageView.layer.cornerRadius  = 10
            logoImageView.layer.masksToBounds = true
            cell.addSubview(logoImageView)
            break
        
        case (0,1):
            cell.textLabel?.text = "昵称"
            cell.detailTextLabel?.text = self.showName
            cell.detailTextLabel?.textColor = UIColor.blackColor()
        case (1,1):
            cell.textLabel?.text = "用户名"
            cell.detailTextLabel?.text = GeneralFactory.currentUser.username
            
        case (2,1):
            cell.textLabel?.text = "二维码"
            
        case (3,1):
            cell.textLabel?.text = "我的地址"
    
            break
        case (0,2):
            cell.textLabel?.text = "性别"
            break
        case (1,2):
            cell.textLabel?.text = "地区"
        case (2,2):
            cell.textLabel?.text = "个性签名"
        default:
            break
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        let cellPosition = (row:indexPath.row,section:indexPath.section)
        switch cellPosition {
        case (0,0):
            let vc = userTouXiangViewController()
//            vc.touxiangImage = self.userTouXiang
//            vc.touxiangImage?.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)
//            vc.touxiangImageScrollView?.zoomScale =  1
            self.navigationController?.pushViewController(vc, animated: true)
           break
        case(0,1):
            let showNameVC = showName_ViewController()
            showNameVC.showNameString = self.showName
            showNameVC.showNameTextFieldBlock = {(showName)in
                self.showName = showName
                self.tableView?.reloadData()
            }
            self.navigationController?.pushViewController(showNameVC, animated: true)

        default:
            break
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.tableView?.reloadData()
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
       
    }
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
