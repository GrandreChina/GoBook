//
//  commentViewController.swift
//  GoBook
//
//  Created by Grandre on 16/5/6.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class commentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,InputViewDelegate {

    var tableView:UITableView?
    var dataArray =  NSMutableArray()
    var BookObject:AVObject?
    
    var input:InputView?
    var layView:UIView?
    var keyboardHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.view.viewWithTag(1234)?.hidden = true
        
        let titleLabel = UILabel(frame: CGRectMake(0,20,SCREEN_WIDTH,44))
        titleLabel.text = "讨论区"
        titleLabel.font = UIFont(name: MY_FONT, size: 20)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = MAIN_RED
        self.view.addSubview(titleLabel)
        
        self.tableView = UITableView(frame: CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIGHT - 64 - 44))
        self.tableView?.registerClass(discussCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.tableFooterView = UIView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: "footerRefresh")
        
        self.input = (NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil).last as! InputView)
        self.input?.frame = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)
        self.input?.delegate = self
        self.view.addSubview(self.input!)
        
        self.layView = UIView(frame: self.view.frame)
        self.layView?.alpha = 0
        self.layView?.backgroundColor = UIColor.grayColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(commentViewController.tapLayView))
        self.layView?.addGestureRecognizer(tap)
        self.view.insertSubview(self.layView!, belowSubview: self.input!)
        
        
        
        
    }
    func keyboardWillHide(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.layView?.alpha = 0
            self.input?.bottom = SCREEN_HEIGHT
            }) { (finish) -> Void in
                self.layView?.hidden = true
                self.input?.resetInputView()
                self.input?.inputTextView?.text = ""
                self.input?.bottom = SCREEN_HEIGHT
        }
    }
    func keyboardWillShow(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyboardHeight = keyboardHeight
        self.layView?.hidden = false
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.layView?.alpha = 0.2
            self.input?.bottom = SCREEN_HEIGHT - keyboardHeight
            }) { (finish) -> Void in
                
        }
    }
    func textViewHeightDidChange(height: CGFloat) {
        self.input?.height = height+10
        self.input?.bottom = SCREEN_HEIGHT - self.keyboardHeight
    }
    func publishButtonDidClick(button: UIButton!) {
        ProgressHUD.show("提交评论ing")
        var count = 0
        for i in (self.input?.inputTextView?.text.characters)!{
            if i == " " || i == "\n"{
                count += 1
            }
        }
        if count == self.input?.inputTextView?.text.characters.count{
            print("没写东西或者都是空格")
            ProgressHUD.showError("没写什么哦", interaction: true)
        }else{
            let object = AVObject(className: "discuss")
            object.setObject(self.input?.inputTextView?.text, forKey: "text")
            object.setObject(AVUser.currentUser(), forKey: "user")
            object.setObject(self.BookObject, forKey: "BookObject")
            object.saveInBackgroundWithBlock { (success, error) -> Void in
                if success{
                    ProgressHUD.showSuccess("评论成功", interaction: false)
                    self.input?.inputTextView!.resignFirstResponder()
                    
                    self.BookObject?.incrementKey("discussNumber")
                    self.BookObject?.saveInBackground()
                }else{
                    
                }
            }
            
        }
    }
    func tapLayView(){
        self.input?.inputTextView!.resignFirstResponder()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? discussCell
        cell?.initFrame()
        let object = self.dataArray[indexPath.row] as! AVObject
        
        cell?.nameLabel?.text = (object["user"] as! AVUser).username
        cell?.detailLabel?.text = object["text"] as? String
        cell?.avatarImage?.image = UIImage(named: "Avatar")
        
        let date = object["createdAt"] as! NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.dateLabel?.text = format.stringFromDate(date)
        
        
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let object = self.dataArray[indexPath.row] as? AVObject
        let text = object!["text"] as? NSString
        let textSize = text?.boundingRectWithSize(CGSizeMake(SCREEN_WIDTH-56-8,0), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).size
        
        return (textSize?.height)! + 30 + 25
    }
    func sure(){
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    func headerRefresh(){
        let quary = AVQuery(className: "discuss")
//        quary.orderByAscending("createdAt")
        quary.orderByDescending("createdAt")
        quary.limit = 20
        quary.skip = 0
        quary.whereKey("user", equalTo: AVUser.currentUser())
        quary.whereKey("BookObject", equalTo: self.BookObject)
        quary.includeKey("user")
        quary.includeKey("BookObject")
        quary.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_header.endRefreshing()
            
            self.dataArray.removeAllObjects()
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
        }
    }
    func footerRefresh(){
        let query = AVQuery(className: "discuss")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.skip = self.dataArray.count
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.BookObject)
        query.includeKey("user")
        query.includeKey("BookObject")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_footer.endRefreshing()
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self.input!)
        print("-------commentViewController release")
    }

   
}
