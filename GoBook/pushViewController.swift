//
//  pushViewController.swift
//  GoBook
//
//  Created by Grandre on 16/3/23.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class pushViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate {
    var dataArr = NSMutableArray()
    var navigationbar:UIView!
    var tableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setNavigationBar()
        
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView?.tableFooterView = UIView()
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.registerClass(push_cell.classForCoder(), forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerRefresh))
        self.tableView?.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBar(){
        
        navigationbar = UIView(frame: CGRectMake(0,-20,SCREEN_WIDTH,65))
        navigationbar.backgroundColor = MAIN_RED
        
        self.navigationController?.navigationBar.addSubview(navigationbar)
        
        let addBookBtn = UIButton(frame: CGRectMake(20,20,SCREEN_WIDTH,45))
        addBookBtn.setImage(UIImage(named: "plus circle"), forState: .Normal)
        addBookBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        addBookBtn.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        
        addBookBtn.setTitle(" 新建书评", forState: .Normal)
        addBookBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        addBookBtn.contentHorizontalAlignment = .Left
        addBookBtn.titleLabel?.font = UIFont(name: MY_FONT, size: 18)
        addBookBtn.addTarget(self, action: "presentNewBook", forControlEvents: .TouchUpInside)
        navigationbar.addSubview(addBookBtn)
    }

    func headerRefresh(){
        let query = AVQuery(className: "BOOK")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.skip = 0
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_header.endRefreshing()
            if results != nil{
                self.dataArr.removeAllObjects()
                self.dataArr.addObjectsFromArray(results)
            }
            self.tableView?.reloadData()
            
        }
    }
    func footerRefresh(){
        let query = AVQuery(className: "BOOK")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.skip = self.dataArr.count
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_footer.endRefreshing()
            if error == nil{
                self.dataArr.addObjectsFromArray(results)
                self.tableView?.reloadData()
            }
        }
    }
    func presentNewBook(){
        let presentNewBook = presentNewBookController()
        presentViewController(presentNewBook, animated: true, completion: nil)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? push_cell
        
        cell?.rightUtilityButtons = self.returnRightBtn()
        cell?.leftUtilityButtons = self.returnLeftBtn()
        cell?.delegate = self
        
        
        let data = dataArr[indexPath.row] as! AVObject
        cell?.BookName?.text = "《"+(data["BookName"] as! String)+" 》标题:"+(data["title"] as! String)
        cell?.Editor?.text = "作者:"+(data["BookEditor"] as! String)
        let date = data["createdAt"] as? NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.more?.text = format.stringFromDate(date!)
//        cell?.selectionStyle  = .None
        let coverFile = data["cover"] as? AVFile
        cell?.cover?.sd_setImageWithURL(NSURL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
//       let imageData =  NSData(contentsOfURL: NSURL(string: (coverFile?.url)!)!)
//        cell?.cover?.image = UIImage(data: imageData!)
//        
        return cell!
    }
//    这里的btn一定要设置背景颜色
    func returnRightBtn()->[AnyObject]{
        let btn1 = UIButton(frame: CGRectMake(0,0,88,88))
        btn1.backgroundColor = UIColor.orangeColor()
        btn1.setTitle("编辑", forState: .Normal)
        
        let btn2 = UIButton(frame: CGRectMake(0,0,88,88))
        btn2.backgroundColor = UIColor.redColor()
        btn2.setTitle("删除", forState: .Normal)
        return [btn1,btn2]
    }
    func returnLeftBtn()->[AnyObject]{
        let btn1 = UIButton(frame: CGRectMake(0,0,88,88))
        btn1.backgroundColor = UIColor.orangeColor()
        btn1.setTitle("编辑", forState: .Normal)
//        btn1.setImage(UIImage(named: "redheart"), forState: .Normal)
        
        let btn2 = UIButton(frame: CGRectMake(0,0,88,88))
        btn2.backgroundColor = UIColor.redColor()
        btn2.setTitle("删除", forState: .Normal)
        return [btn1,btn2]
        
//        let btnArr = NSMutableArray()
//        btnArr.sw_addUtilityButtonWithColor(UIColor.orangeColor(), icon: UIImage(named: "redheart"))
//        return btnArr as [AnyObject]
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("good")
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)

        let vc = BookDetailViewController()
        vc.BookObject = dataArr[indexPath.row] as? AVObject
        vc.hidesBottomBarWhenPushed = true
//        vc.navigationController?.navigationBar.translucent = false
//        vc.tabBarController?.tabBar.translucent = false
//        vc.automaticallyAdjustsScrollViewInsets = true
//        下面一句可设置子视图下移至导航条下面
//        vc.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, scrollingToState state: SWCellState) {
        
    }
//    点击了哪个cell的哪个btn
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        
        
        
        
    }
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        let indexPath = self.tableView?.indexPathForCell(cell)
        let object = self.dataArr[(indexPath?.row)!] as! AVObject
        if index == 0{//编辑操作
            let vc = presentNewBookController()
            vc.BookObject = object
            vc.fixType = "fix"
            self.presentViewController(vc, animated: true, completion: { () -> Void in
                
            })
        }else{//删除操作
            ProgressHUD.show("")
            
            let discussQuery = AVQuery(className: "discuss")
            discussQuery.whereKey("BookObject", equalTo: object)
            discussQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                for Book in results {
                    let BookObject = Book as? AVObject
                    BookObject?.deleteInBackground()
                }
            })
            
            let loveQuery = AVQuery(className: "Love")
            loveQuery.whereKey("BookObject", equalTo: object)
            loveQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                for Book in results {
                    let BookObject = Book as? AVObject
                    BookObject?.deleteInBackground()
                }
            })
            
            object.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    ProgressHUD.showSuccess("删除成功")
                    self.dataArr.removeObjectAtIndex((indexPath?.row)!)
                    self.tableView?.reloadData()
              
                }else{
                    
                }
            })
        }

    }
//    定制哪个cell可以左滑或者右滑
    func swipeableTableViewCell(cell: SWTableViewCell!, canSwipeToState state: SWCellState) -> Bool {
        let indexPath = self.tableView?.indexPathForCell(cell)
        if indexPath?.row == 0 && state == .CellStateLeft{
            return false
        }
        return true
    }
//    当滑动另一个cell时，其他cell收回去
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    func swipeableTableViewCellDidEndScrolling(cell: SWTableViewCell!) {
//        cell.hideUtilityButtonsAnimated(true)
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationbar.hidden = false
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationbar.hidden = true
    }
   
 }
