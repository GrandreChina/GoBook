//
//  BookDetailViewController.swift
//  GoBook
//
//  Created by Grandre on 16/4/22.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController,BookTabBarDelegate,InputViewDelegate,HZPhotoBrowserDelegate{
    var BookObject:AVObject?
    var BookTitleView:BookDetailView?
    var BookTabBarView:BookTabBar?
    var BookDescriptionTextView:UITextView?
    var input:InputView?
    var layView:UIView?
    var keyBoardHeight:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
//        去掉backitem的titile
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        
        
        self.initBookDetailView()
        
        BookTabBarView = BookTabBar(frame: CGRectMake(0,SCREEN_HEIGHT-40,SCREEN_WIDTH,40))
        BookTabBarView?.delegate = self
        self.view.addSubview(BookTabBarView!)
        
        BookDescriptionTextView = UITextView(frame: CGRectMake(0,64+SCREEN_HEIGHT/4,SCREEN_WIDTH,SCREEN_HEIGHT - 64 - SCREEN_HEIGHT/4 - 40))
        BookDescriptionTextView?.editable = false
        BookDescriptionTextView?.text = self.BookObject!["description"] as! String
        BookDescriptionTextView?.font = UIFont(name: MY_FONT, size: 15)
        self.view.addSubview(BookDescriptionTextView!)
        
        self.isLove()
       
        
    }
    
    /**
     进来一开始先判断是否已经点赞
     */
    func isLove(){
        let quary = AVQuery(className: "Love")
        quary.whereKey("user", equalTo: AVUser.currentUser())
        quary.whereKey("BookObject", equalTo: self.BookObject)
        quary.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil && results.count != 0{
                print("hello")
                let btn = self.BookTabBarView?.viewWithTag(2) as? UIButton
                btn?.setImage(UIImage(named: "solidheart"), forState: .Normal)
            }

        }
    }
    /**
     每当页面出现的时候，先移除之前添加的通知，再重新添加
    */
    override func viewWillAppear(animated: Bool) {
       
        if self.input != nil{
         NSNotificationCenter.defaultCenter().removeObserver(self.input!)
        NSNotificationCenter.defaultCenter().addObserver(self.input!, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.input!, selector: Selector("keyboardWillHide"), name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    override func viewWillDisappear(animated: Bool) {
        if self.input != nil{
            NSNotificationCenter.defaultCenter().removeObserver(self.input!)
        }
        
    }
    
    func keyboardWillHide(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
//            键盘消失的时候，使input框移到屏幕底下外面
            self.input?.bottom = SCREEN_HEIGHT+(self.input?.height)!
            self.layView?.alpha = 0
            }) { (finish) -> Void in
            self.layView?.hidden = true
            self.input?.resetInputView()
            self.input?.bottom = SCREEN_HEIGHT+(self.input?.height)!
            self.input?.inputTextView?.text = ""

                
        }
    }
    func keyboardWillShow(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyBoardHeight = keyboardHeight
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.input?.bottom = SCREEN_HEIGHT - keyboardHeight
            self.layView?.alpha = 0.2
            }) { (finish) -> Void in
                
        }
    }
 
    func textViewHeightDidChange(height: CGFloat) {
        self.input?.height = height+10
        self.input?.bottom = SCREEN_HEIGHT - self.keyBoardHeight
    }
    func publishButtonDidClick(button: UIButton!) {
        ProgressHUD.show("提交评论ing")
//        print(self.input?.inputTextView?.text)
//        if self.input!.inputTextView!.text.isEmpty{
//            print("meixie dongxi o ")
//        }
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
    
    func comment(){
        if input == nil{
            self.input = NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil).last as? InputView
            self.input?.frame = CGRectMake(0,SCREEN_HEIGHT-44,SCREEN_WIDTH,44)
            self.input?.delegate = self
            self.view.addSubview(self.input!)
            
        }
        if layView == nil{
            self.layView = UIView(frame: self.view.frame)
            self.layView?.backgroundColor = UIColor.grayColor()
            self.layView?.alpha = 0
            let tap = UITapGestureRecognizer(target: self, action: Selector("tapInputView"))
            self.layView?.addGestureRecognizer(tap)
            self.view.insertSubview(self.layView!, belowSubview: self.input!)

        }
        self.layView?.hidden = false
        self.input?.inputTextView?.becomeFirstResponder()
        self.input?.inputTextView?.text = ""
        print("0")
    }
    func tapInputView(){
        self.input?.inputTextView?.resignFirstResponder()
    }
    func commentController(){
        let vc = commentViewController()
        GeneralFactory.addTitleWithTitle(vc, leftTitle: "", rightTitle: "关闭")
        vc.BookObject = self.BookObject
        vc.tableView?.mj_header.beginRefreshing()
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
        print("1")
    }
    
    func likeBook(btn:UIButton){
        btn.enabled = false
        btn.setImage(UIImage(named: "redheart"), forState: .Normal)
        
        let query = AVQuery(className: "Love")
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.BookObject)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil && results.count != 0{
                for var object in results {
                    object = (object as? AVObject)!
                    object.deleteEventually()
                }
                
                self.BookObject?.incrementKey("loveNumber", byAmount: NSNumber(int: -1))
                self.BookObject?.saveInBackground()
                
                btn.setImage(UIImage(named: "heart"), forState: .Normal)
            }else{
                let object = AVObject(className: "Love")
                object.setObject(AVUser.currentUser(), forKey: "user")
                object.setObject(self.BookObject, forKey: "BookObject")
                object.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success{
                        btn.setImage(UIImage(named: "solidheart"), forState: .Normal)
                        self.BookObject?.incrementKey("loveNumber")
                        self.BookObject?.saveInBackground()
                        
                    }else{
                        ProgressHUD.showError("操作失败")
                        
                    }
                })
            }
            btn.enabled = true

        print("2")
        }
    }
    func shareAction(){
        print("3")
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        
//        shareParames.SSDKSetupShareParamsByText("分享内容",
//            images : self.BookTitleView?.coverImage?.image,
//            url : NSURL(string:"http://mob.com"),
//            title : "分享标题",
//            type : SSDKContentType.Image)
        shareParames.SSDKSetupWeChatParamsByText("I Love You", title: "山猪", url: NSURL(string:"http://www.jianshu.com/p/83463395e137"), thumbImage: nil, image: self.BookTitleView?.coverImage?.image, musicFileURL: nil, extInfo: "Grandre", fileData: nil, emoticonData: nil, type: SSDKContentType.App, forPlatformSubType: SSDKPlatformType.SubTypeWechatSession)

        
        //2.进行分享
//        无选择界面，直接跳转
//        ShareSDK.share(.TypeWechat, parameters: shareParames) { (state, userData, contentEntity, error) -> Void in
//            switch state{
//            case SSDKResponseState.Success:
//                ProgressHUD.showSuccess("分享成功")
//                break
//            case SSDKResponseState.Fail:
//                ProgressHUD.showError("分享失败")
//                break
//            case SSDKResponseState.Cancel:
//                ProgressHUD.showError("已取消分享")
//                break
//            default:
//                break
//            }
//        }
//        有选择界面
        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { (state, platForm, userdata, contentEntity, error, success) -> Void in
            
            switch state{
            case SSDKResponseState.Success:
                ProgressHUD.showSuccess("分享成功")
                break
            case SSDKResponseState.Fail:
                ProgressHUD.showError("分享失败")
                print("取消分享")
                break
            case SSDKResponseState.Cancel:
                ProgressHUD.showError("已取消分享")
                break
            default:
                break
            }
            
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initBookDetailView(){
        BookTitleView = BookDetailView(frame:CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIGHT/4))
        BookTitleView?.BookName?.text = "《" + (BookObject!["BookName"] as? String)! + " 》"
        BookTitleView?.Editor?.text = "作者:"+(BookObject!["BookEditor"] as! String)
        
        let coverFile = self.BookObject!["cover"] as? AVFile
        self.BookTitleView?.coverImage?.sd_setImageWithURL(NSURL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
        let tap =  UITapGestureRecognizer(target: self, action: #selector(self.photoBrowserView))
        self.BookTitleView?.coverImage?.addGestureRecognizer(tap)
        self.BookTitleView?.coverImage?.userInteractionEnabled = true
        
//        leanCloud上保存的是指针，获取的时候再根据指针fetch一下
        let user = BookObject!["user"] as! AVUser
        user.fetchInBackgroundWithBlock { (avUser, error) -> Void in
            self.BookTitleView?.userName?.text = "编者：" + (avUser as! AVUser).username
        }
        
        let date = BookObject!["createdAt"] as! NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yy-MM-dd"
        BookTitleView?.date?.text = format.stringFromDate(date)
        
        let scoreString = BookObject!["score"] as! String
        BookTitleView?.score?.show_star = Int(scoreString)!
        
        
        let scanNumber = self.BookObject!["scanNumber"] as! NSNumber
        let loveNumber = self.BookObject!["loveNumber"] as! NSNumber
        let discussNumber = self.BookObject!["discussNumber"] as! NSNumber
        self.BookTitleView?.more?.text = "\(loveNumber)个喜欢.\(discussNumber)次评论.\(scanNumber)次浏览"
        
        self.BookObject?.incrementKey("scanNumber")
        self.BookObject?.saveInBackground()
        
        self.view.addSubview(BookTitleView!)
    }

    func photoBrowserView(){
        let photoBrowser = HZPhotoBrowser()
        photoBrowser.imageCount = 1
        photoBrowser.currentImageIndex = 0
        photoBrowser.delegate = self
        photoBrowser.show()
    }
//    高清图模式
    func photoBrowser(browser: HZPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
        let url = (self.BookObject!["cover"] as! AVFile).url
        return NSURL(string:url)
    }
//    缩略图预览模式
    func photoBrowser(browser: HZPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
        return self.BookTitleView?.coverImage?.image
    }
    
    deinit{
        print("BookDetail_ViewController release")
    }
}
