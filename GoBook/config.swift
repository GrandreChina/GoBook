//
//  config.swift
//  GoBook
//
//  Created by Grandre on 16/3/23.
//  Copyright © 2016年 革码者. All rights reserved.
//

import Foundation

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height


let MAIN_RED = UIColor(colorLiteralRed: 235/255, green: 114/255, blue: 118/255, alpha: 1)

let MY_FONT = "Bauhaus ITC"

func RGB(r:Float,g:Float,b:Float)->UIColor{
    return UIColor(colorLiteralRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}