//
//  PhotoPickerViewController.swift
//  GoBook
//
//  Created by Grandre on 16/3/24.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

protocol GetImageFromPhotoPicker:class{
    func getImageFromPicker(image:UIImage)
}
protocol SaveImageToPhotoAlbum:class {
    func saveImageToPhotoAlbum()
}
class PhotoPickerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    weak var delegate:GetImageFromPhotoPicker?
    weak var delegare2:SaveImageToPhotoAlbum?
    var alert:UIAlertController?
    var picker:UIImagePickerController?
    var presentFromTouXiang:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    init(){
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .OverFullScreen
        self.view.backgroundColor = UIColor.clearColor()
        self.picker = UIImagePickerController()
        self.picker?.allowsEditing = false
        self.picker?.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        if(self.alert == nil){
            self.alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            self.alert?.addAction(UIAlertAction(title: "从相册选择", style: .Default, handler: { (action) -> Void in
                self.localPhoto()
            }))
            self.alert?.addAction(UIAlertAction(title: "打开相机", style: .Default, handler: { (action) -> Void in
                self.takePhoto()
            }))
            self.alert?.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }))
            if self.presentFromTouXiang{
                self.alert?.addAction(UIAlertAction(title: "保存", style: .Default, handler: { (action) -> Void in
                    self.delegare2?.saveImageToPhotoAlbum()
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                }))
            }
            self.presentViewController(self.alert!, animated: true, completion: { () -> Void in
                
            })
        }
    }
    /**
     打开相机
     */
    func takePhoto(){
        if(UIImagePickerController.isSourceTypeAvailable(.Camera)){
            
            self.picker!.sourceType = .Camera
            self.presentViewController(self.picker!, animated: true, completion: { () -> Void in
                
            })
            
            
            
        }else{
            let alertView = UIAlertController(title: "此机型无相机", message: nil, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "关闭", style: .Cancel, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }))
            self.presentViewController(alertView, animated: true, completion: { () -> Void in
                
            })
        }
    }
    /**
     *  打开相册
     */
    func localPhoto(){
        self.picker!.sourceType = .PhotoLibrary
        self.presentViewController(self.picker!, animated: true) { () -> Void in
            
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.picker?.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        })
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.picker?.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
//将图片传给父控制器
             self.delegate!.getImageFromPicker(image)
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
