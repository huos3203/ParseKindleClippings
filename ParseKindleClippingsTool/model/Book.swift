//
//  File.swift
//  ParseKindleClippings
//
//  Created by huoshuguang on 2017/5/29.
//  Copyright © 2017年 huoshuguang. All rights reserved.
//

import Foundation

class Book
{
    //
    var name = ""
    var author = ""
    var marks:[Mark] = []
    var notes:[Note] = []
    
    init(name:String)
    {
        self.name = name
    }
    
    //整合marks 和 notes
    func mergeNoteToMarks()
    {
        //检索,谓词法
        
        
    }
}
