//
//  discussCell.swift
//  GoBook
//
//  Created by Grandre on 16/5/6.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class discussCell: UITableViewCell {

    var avatarImage:UIImageView?
    var nameLabel:UILabel?
    var detailLabel:UILabel?
    var dateLabel:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
    }
    func initFrame(){
        for i in self.contentView.subviews{
            i.removeFromSuperview()
        }
        self.avatarImage = UIImageView(frame: CGRectMake(8,8,40,40))
        self.avatarImage?.layer.cornerRadius = 20
        self.avatarImage?.layer.masksToBounds = true
        self.contentView.addSubview(self.avatarImage!)
        
        self.nameLabel = UILabel(frame: CGRectMake(56,8,SCREEN_WIDTH - 56 - 8,15))
        self.nameLabel?.font = UIFont(name: MY_FONT, size: 13)
        self.nameLabel?.textColor = MAIN_RED
        self.contentView.addSubview(self.nameLabel!)
        
        self.dateLabel = UILabel(frame: CGRectMake(56,self.frame.size.height-8-10,SCREEN_WIDTH-56-8,10))
        self.dateLabel?.font = UIFont(name: MY_FONT, size: 13)
        self.dateLabel?.textColor = UIColor.grayColor()
        self.contentView.addSubview(self.dateLabel!)
        
        self.detailLabel = UILabel(frame: CGRectMake(56,30,SCREEN_WIDTH-56-8,
            self.frame.size.height - 30 - 25))
        self.detailLabel?.font = UIFont(name: MY_FONT, size: 15)
        self.detailLabel?.numberOfLines = 0
        self.contentView.addSubview(self.detailLabel!)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
