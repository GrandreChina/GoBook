//
//  presentNewBookController.swift
//  GoBook
//
//  Created by Grandre on 16/3/24.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class presentNewBookController: UIViewController,BookTitleDelegate,GetImageFromPhotoPicker,VPImageCropperDelegate,UITableViewDelegate,UITableViewDataSource{

    var BookTitle:BookTitleView?
    var tableView:UITableView?
    var titleArr:Array<String> = ["标题","评分","分类","书评"]
    var Book_Title = ""
    var scoreView:LDXScore?
    var showScore = false
    
    var type:String = "文学"
    var detailType:String = "文学"
    
    var Book_Description = " "
    
//    编辑
    var BookObject:AVObject?
    var fixType:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.view.backgroundColor = UIColor.whiteColor()
       GeneralFactory.addTitleWithTitle(self, leftTitle: "取消", rightTitle: "发布")
        self.BookTitle = BookTitleView(frame: CGRectMake(0,40,SCREEN_WIDTH,160))
        self.BookTitle?.delegate = self
        self.view.addSubview(BookTitle!)
        
        tableView = UITableView(frame: CGRectMake(0,200,SCREEN_WIDTH,SCREEN_HEIGHT - 200), style: UITableViewStyle.Grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
//        让没有内容的线条消失
        tableView?.tableFooterView = UIView()
        tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView?.backgroundColor = UIColor(colorLiteralRed: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        self.view.addSubview(tableView!)
        
        self.scoreView = LDXScore(frame: CGRectMake(100,10,200,35))
        self.scoreView?.isSelect = true
        self.scoreView?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        self.scoreView?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        self.scoreView?.max_star = 5
        self.scoreView?.show_star = 5
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uploadBookNotification:", name: "uploadBookNotification", object:nil)
        
        self.fixBook()
        
    }
    deinit{
        print("pushNewBookController reallse")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func uploadBookNotification(notification:NSNotification){
        let uploadSuccess = notification.userInfo!["success"] as! String
        if uploadSuccess == "finish"{
            print("finish upload but wether success is unknown")
            self.clearAllNotice()
        }
        if uploadSuccess == "true"{
            if self.fixType == "fix"{
                ProgressHUD.showSuccess("修改成功")
            }else{
                ProgressHUD.showSuccess("上传成功")
            }
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        }else{
            ProgressHUD.showError("上传失败")
         
            
        }
    }
    func choiceCover() {
        print("success")
        let photoPicker = PhotoPickerViewController()
        photoPicker.delegate = self
        self.presentViewController(photoPicker, animated: true) { () -> Void in
            
        }
        
    }
    func getImageFromPicker(image: UIImage) {
        let croVC = VPImageCropperViewController(image: image, cropFrame: CGRectMake(0,100,SCREEN_WIDTH,SCREEN_WIDTH*1.273), limitScaleRatio: 3)
        croVC.delegate = self
        self.presentViewController(croVC, animated: true) { () -> Void in
            
        }
//        self.BookTitle?.BookCover?.setImage(image, forState: .Normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close(){
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    func sure(){
        let dict = [
            "BookName":(self.BookTitle?.BookName?.text)!,
            "BookEditor":(self.BookTitle?.BookEditor?.text)!,
            "BookCover":(self.BookTitle?.BookCover?.currentImage)!,
            "title":self.Book_Title,
            "score":String((self.scoreView?.show_star)!),
            "type":self.type,
            "detailType":self.detailType,
            "description":self.Book_Description
        ]
//        self.pleaseWait()
        ProgressHUD.show("")
        if self.fixType == "fix"{
            UploadBook.uploadBookInBackground(dict,object: self.BookObject!)
        }else{
            let object = AVObject(className: "BOOK")
            UploadBook.uploadBookInBackground(dict,object: object)
        }
        
        
    }
    
    func imageCropper(cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        self.BookTitle?.BookCover?.setImage(editedImage, forState: .Normal)
        cropperViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func imageCropperDidCancel(cropperViewController: VPImageCropperViewController!) {
        cropperViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        //        下面这种引用方法是自定义的cell
        //        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        if indexPath.row != 1{
            cell.accessoryType = .DisclosureIndicator
        }
        
        cell.textLabel?.text = titleArr[indexPath.row]
        cell.textLabel?.font = UIFont(name: MY_FONT, size: 15)
        cell.detailTextLabel?.font = UIFont(name: MY_FONT, size: 15)
        
        if showScore{
            switch indexPath.row{
            case 0:
                cell.detailTextLabel?.text = self.Book_Title
            case 2:
                cell.selectionStyle = .None
                cell.contentView.addSubview(scoreView!)
            case 3:
                cell.detailTextLabel?.text = self.type + "->" + self.detailType
            case 5:
                cell.accessoryType = .None
                let commentView = UITextView(frame: CGRectMake(4,4,SCREEN_WIDTH-8,80))
                commentView.text = self.Book_Description
                commentView.font = UIFont(name: MY_FONT, size: 14)
                commentView.editable = false
                cell.contentView.addSubview(commentView)
            default:
                break
            }
        }else{//没有中间插入评分行的时候
            switch indexPath.row{
            case 0:
                cell.detailTextLabel?.text = self.Book_Title
            case 2:
                cell.detailTextLabel?.text = self.type + "->" + self.detailType
            case 4:
                cell.accessoryType = .None
                let commentView = UITextView(frame: CGRectMake(4,4,SCREEN_WIDTH-8,80))
                commentView.text = self.Book_Description
                commentView.font = UIFont(name: MY_FONT, size: 14)
                commentView.editable = false
                cell.contentView.addSubview(commentView)
            default:
                break
            }
        }
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if showScore && indexPath.row > 4 {
            return 88
        }else if !self.showScore && indexPath.row > 3 {
            return 88
        }else{
            return 44
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        点击cell之后再把选中取消
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        
        if self.showScore{
        //插入新index后面的row的index才发生了变化，都+1了。但执行的方法不应该变化，所以，把后面的row的index都减一，就对应回原来的执行方法了。
            switch indexPath.row{
            case 0:
                self.tableViewSelectTitile()
            case 1:
                self.tableViewSelectScore()
            case 3:
                self.tableViewSelectType()
            case 4:
                self.tableViewSelectDescription()
            default:
                break
            }
        }else{
            switch indexPath.row{
            case 0:
                self.tableViewSelectTitile()
            case 1:
                self.tableViewSelectScore()
            case 2:
                self.tableViewSelectType()
            case 3:
                self.tableViewSelectDescription()
            default:
                break
            }
        }
    }
        

//    点击另一个cell的时候调用
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableViewSelectTitile(){
        let vc = Push_TitleController()
        GeneralFactory.addTitleWithTitle(vc)
        vc.TitleValueCallBack = {(string) in self.Book_Title = string
        self.tableView?.reloadData()
        }
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
        
    }
    func tableViewSelectScore(){
        self.showScore = !self.showScore
        let tempIndexPath = [NSIndexPath(forRow: 2, inSection: 0)]
       
        self.tableView?.beginUpdates()
        if self.showScore{
            self.tableView?.insertRowsAtIndexPaths(tempIndexPath, withRowAnimation: .Left)
            self.titleArr.insert("", atIndex: 2)
        }else{
            self.titleArr.removeAtIndex(2)
            self.tableView?.deleteRowsAtIndexPaths(tempIndexPath, withRowAnimation: .Right)
            
        }
        self.tableView?.endUpdates()
        
    }
    func tableViewSelectType(){
        let vc = Push_TypeController()
        GeneralFactory.addTitleWithTitle(vc)
        let btn1 = vc.view.viewWithTag(1234) as! UIButton
        let btn2 = vc.view.viewWithTag(1235) as! UIButton
        btn1.setTitleColor(RGB(38, g: 82, b: 67), forState: .Normal)
        btn2.setTitleColor(RGB(38, g: 82, b: 67), forState: .Normal)
        vc.callBack = {(type:String,detailType:String) in
            self.type = type
            self.detailType = detailType
            self.tableView?.reloadData()
            
        }
        
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
    }
    func tableViewSelectDescription(){
        let vc = Push_DescriptionController()
        GeneralFactory.addTitleWithTitle(vc)
        vc.textView?.text = self.Book_Description//一定要工厂模式后面赋值，因为此时控制器才实例过程完成
        vc.callBack = {(description:String) in
        self.Book_Description = description
//            每次回调传回description时先删除掉上一次的last cell。
//            再根据是否传回有内容再决定是否添加description cell。
        if self.titleArr.last == "" {
            self.titleArr.removeLast()
        }
        if description != "" {
            self.titleArr.append("")
        }
        self.tableView?.reloadData()
 
        }
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
    }
    
    func fixBook(){
        if self.fixType == "fix" {
            self.BookTitle?.BookName?.text = self.BookObject!["BookName"] as? String
            self.BookTitle?.BookEditor?.text = self.BookObject!["BookEditor"] as? String
            let coverFile = self.BookObject!["cover"] as? AVFile
            coverFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                self.BookTitle?.BookCover?.setImage(UIImage(data: data), forState: .Normal)
            })
            
            self.Book_Title = (self.BookObject!["title"] as? String)!
            self.type = (self.BookObject!["type"] as? String)!
            self.detailType = (self.BookObject!["detailType"] as? String)!
            self.Book_Description = (self.BookObject!["description"] as? String)!
            self.scoreView?.show_star = (Int)((self.BookObject!["score"] as? String)!)!
            if self.Book_Description != "" {
                self.titleArr.append("")
            }
        }
    }
}
