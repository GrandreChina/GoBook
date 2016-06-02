//
//  BookTabBar.swift
//  GoBook
//
//  Created by Grandre on 16/4/25.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit



protocol BookTabBarDelegate:class{
    func comment()
    func commentController()
    func likeBook(btn:UIButton)
    func shareAction()
}


class BookTabBar: UIView {

   weak var delegate:BookTabBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let imageName = ["Pen 4","chat 3","heart","box outgoing"]
        for i in 0...3{
            let btn = UIButton(frame: CGRectMake(CGFloat(i) * frame.size.width/4,0,frame.size.width/4,frame.size.height))
            btn.setImage(UIImage(named: imageName[i]), forState: .Normal)
            btn.imageView?.contentMode = .ScaleAspectFit
            btn.tag = i
            btn.addTarget(self, action: #selector(BookTabbarAction(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(btn)
            
            
        }
    }
    func BookTabbarAction(btn:UIButton){
        switch(btn.tag){
        case 0:
            delegate?.comment()
            break
        case 1:
            delegate?.commentController()
            break
        case 2:
            delegate?.likeBook(btn)
            break
        case 3:
            delegate?.shareAction()
            break
        default:
            break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        for i in 1..<4{
            
            CGContextSetLineWidth(context, 0.5)
            CGContextSetStrokeColorWithColor(context, MAIN_RED.CGColor)
            CGContextMoveToPoint(context, CGFloat(i)*rect.size.width/4, rect.size.height*0.2)
            CGContextAddLineToPoint(context, CGFloat(i)*rect.size.width/4, rect.size.height*0.8)
            CGContextStrokePath(context)
            
        }
        
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context,rect.size.width, 0)
        CGContextStrokePath(context)
        
    }
   

}
