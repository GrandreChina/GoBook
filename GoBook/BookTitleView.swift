//
//  BookTitleView.swift
//  GoBook
//
//  Created by Grandre on 16/3/24.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

@objc protocol BookTitleDelegate{
    optional func choiceCover()
}

class BookTitleView: UIView {

    var BookCover:UIButton?
    var BookName:JVFloatLabeledTextField?
    var BookEditor:JVFloatLabeledTextField?
    
    weak var delegate:BookTitleDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.BookCover = UIButton(frame: CGRectMake(10,8,110,141))
        self.BookCover?.setImage(UIImage(named: "Cover"), forState: .Normal)
        self.addSubview(BookCover!)
        self.BookCover?.addTarget(self, action: #selector(choiceCover), forControlEvents: .TouchUpInside)
        
        self.BookName = JVFloatLabeledTextField(frame: CGRectMake(128,40+8,SCREEN_WIDTH-128-15,40))
        self.BookEditor = JVFloatLabeledTextField(frame: CGRectMake(128,100+8,SCREEN_WIDTH-128-15,40))
        self.BookName?.placeholder = "书名"
        self.BookEditor?.placeholder = "作者"
        self.BookName?.floatingLabelFont = UIFont(name: MY_FONT, size: 20)
        self.BookEditor?.floatingLabelFont = UIFont(name: MY_FONT, size: 20)
//        self.BookName?.floatingLabelYPadding = CGFloat(-5)
     
        self.BookName?.font = UIFont(name: MY_FONT, size: 18)
        self.BookEditor?.font = UIFont(name: MY_FONT, size: 18)
        self.addSubview(BookName!)
        self.addSubview(BookEditor!)
        
        
        
        
    }
//    委托自己的控制器去弹出另一控制器
    func choiceCover(){
        self.delegate?.choiceCover!()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
