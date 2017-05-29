//
//  Mark.swift
//  ParseKindleClippings
//
//  Created by huoshuguang on 2017/5/29.
//  Copyright © 2017年 huoshuguang. All rights reserved.
//

import Cocoa

class Mark
{
    //位置 ，时间，内容
    var start = ""
    var end = ""
    var time = ""
    var content = ""
    init(start:String,end:String,time:String,content:String)
    {
        self.start = start
        self.end = end
        self.time = time
        self.content = content
    }
}

