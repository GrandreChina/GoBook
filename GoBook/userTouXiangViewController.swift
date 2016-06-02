//
//  userTouXiangViewController.swift
//  GoBook
//
//  Created by Grandre on 16/5/27.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class userTouXiangViewController: UIViewController,UIScrollViewDelegate,GetImageFromPhotoPicker,VPImageCropperDelegate,SaveImageToPhotoAlbum{
    var touxiangImageScrollView:UIScrollView?
    var touxiangImage:UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .Plain, target: self, action: #selector(self.rightBtnTapped))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.rightBtnTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_more_black"), style: .Plain, target: self, action: #selector(self.rightBtnTapped))
//       一定一定要注意添加下面这句代码！！！
//        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.uploadTouXiangNotification(_:)
            ), name: "uploadTouXiangNotification", object: nil)

        self.touxiangImage = UIImageView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH))
//      self.touxiangImage?.image = UIImage()
//        self.touxiangImage?.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)
        self.touxiangImage?.tag = 1000
        
        self.touxiangImageScrollView = UIScrollView(frame:         CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH/2, SCREEN_WIDTH, SCREEN_WIDTH))
        
        self.touxiangImageScrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)

        self.touxiangImageScrollView?.backgroundColor = UIColor.whiteColor()
        self.touxiangImageScrollView?.addSubview(self.touxiangImage!)
//        self.touxiangImageScrollView!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        self.touxiangImageScrollView?.delegate = self
        self.touxiangImageScrollView?.maximumZoomScale = 2
        self.touxiangImageScrollView?.minimumZoomScale = 0.1
        self.touxiangImageScrollView?.zoomScale = 1
        self.touxiangImageScrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
       
        self.view.addSubview(self.touxiangImageScrollView!)
        
        self.initTapGuesture()
    }
    func initTapGuesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        self.touxiangImageScrollView?.addGestureRecognizer(doubleTap)
    }
    func doubleTapAction(){
        if self.touxiangImageScrollView?.zoomScale < 2{
            UIView.animateWithDuration(0.5, animations: { 
                self.touxiangImageScrollView?.zoomScale = 2
            })
            
        }else{
            UIView.animateWithDuration(0.5, animations: {
                self.touxiangImageScrollView?.zoomScale = 1
            })
            
        }
    }
    func uploadTouXiangNotification(notification:NSNotification){
        let uploadSuccess = notification.userInfo!["success"] as! String
        if uploadSuccess == "finish"{
            print("finish upload but wether success is unknown")
//            self.clearAllNotice()
        }
        if uploadSuccess == "true"{
            ProgressHUD.showSuccess("上传成功")
            
//            self.dismissViewControllerAnimated(true, completion: { () -> Void in})
        }
        else{
            ProgressHUD.showError("上传失败")
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return  scrollView.viewWithTag(1000)

    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        print("-------did zoom----")
        
//        /// 缩小的时候，是touxiang始终保持在scrollView中间
        let imageViewSize = self.touxiangImage!.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
       print("------didend zoom scale: \(scale)")
        print("---didend zoom touxiangFrame--\(self.touxiangImage?.frame)")
        if scale < 1 {
            print("suoxiao-----")
//            self.touxiangImageScrollView!.contentMode = .ScaleAspectFit
            self.touxiangImageScrollView?.zoomScale =  1
        }else{
            

        }
    }
    func rightBtnTapped(){
        let photoPicker = PhotoPickerViewController()
        photoPicker.delegate = self
        photoPicker.delegare2 = self
        photoPicker.presentFromTouXiang = true
        self.presentViewController(photoPicker, animated: true) { () -> Void in
            
        }

    }
    func getImageFromPicker(image: UIImage) {
        let croVC = VPImageCropperViewController(image: image, cropFrame: CGRectMake(0,100,SCREEN_WIDTH,SCREEN_WIDTH), limitScaleRatio: 3)
        croVC.delegate = self
        self.presentViewController(croVC, animated: true) { () -> Void in
            
        }

    }
    func imageCropper(cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        ProgressHUD.show("请稍等~")
        let touXiangFile = AVFile(data: UIImageJPEGRepresentation(editedImage, 0.1))
        touXiangFile.saveInBackgroundWithBlock { (success, error) in
            if success{
                let user = AVUser.currentUser()
                user["touXiangFile"] = touXiangFile
                user.saveInBackgroundWithBlock({ (success, error ) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("uploadTouXiangNotification", object: self, userInfo: ["success":"finish"])
                    if success{
                        NSNotificationCenter.defaultCenter().postNotificationName("uploadTouXiangNotification", object: self, userInfo: ["success":"true"])
                         GeneralFactory.creatFile(editedImage)
                         GeneralFactory.readImageFile(self.touxiangImage!)
                    }else{
                        NSNotificationCenter.defaultCenter().postNotificationName("uploadTouXiangNotification", object: self, userInfo: ["success":"false"])
                    }
                })
            }
            else{
                NSNotificationCenter.defaultCenter().postNotificationName("uploadTouXiangNotification", object: self, userInfo: ["success":"false"])
            }
        }
        cropperViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropperDidCancel(cropperViewController: VPImageCropperViewController!) {
        cropperViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    func saveImageToPhotoAlbum() {
        UIImageWriteToSavedPhotosAlbum((self.touxiangImage?.image)!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        if didFinishSavingWithError != nil
        {
            print("error!")
            ProgressHUD.showError("保存失败")
            return
        }
        
        print("image was saved")
        ProgressHUD.showSuccess("保存成功")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
//        self.touxiangImageScrollView?.zoomScale = 1
        GeneralFactory.readImageFile(self.touxiangImage!)
        print("-----viwe will appear")
    }
    override func viewWillDisappear(animated: Bool) {
//        self.touxiangImageScrollView?.zoomScale = 1
        print("-----view disappear")
    }
    deinit{
        print("--------userTouXiangVC release----")
    }
}
