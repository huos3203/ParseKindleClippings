//
//  Note.swift
//  ParseKindleClippings
//
//  Created by huoshuguang on 2017/5/29.
//  Copyright © 2017年 huoshuguang. All rights reserved.
//

import Cocoa

class Note: NSObject
{
    //位置 ，时间，内容
    var locationID = ""
    var time = ""
    var content = ""
    
    init(locationID:String,time:String,content:String)
    {
        self.locationID = locationID
        self.time = time
        self.content = content
    }
}
