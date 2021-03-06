//
//  push_cell.swift
//  GoBook
//
//  Created by Grandre on 16/4/21.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class push_cell: SWTableViewCell {
    
    var BookName:UILabel?
    var Editor:UILabel?
    var more:UILabel?
    
    var cover:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
//    为什么纯代码实例化cell的时候是这个初始化方法？
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        self.BookName = UILabel(frame: CGRectMake(78,8,242,25))
        self.Editor = UILabel(frame: CGRectMake(78,33,242,25))
        self.more = UILabel(frame: CGRectMake(78,66,242,25))
        
        self.BookName?.font = UIFont(name: MY_FONT, size: 15)
        self.Editor?.font = UIFont(name: MY_FONT, size: 15)
        self.more?.font = UIFont(name: MY_FONT, size: 13)
        self.more?.textColor = UIColor.grayColor()
        
        self.contentView.addSubview(self.BookName!)
        self.contentView.addSubview(self.Editor!)
        self.contentView.addSubview(self.more!)
        
        
        self.cover = UIImageView(frame: CGRectMake(8,9,56,70))
        self.contentView.addSubview(self.cover!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
