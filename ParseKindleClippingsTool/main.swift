//
//  main.swift
//  ParseKindleClippingsTool
//
//  Created by huoshuguang on 2017/5/29.
//  Copyright © 2017年 huoshuguang. All rights reserved.
//

import Foundation

let kindle = KindleClipParser()
//解析所有的书
//kindle.ParserLrcWithPath(lrcFilePath: "/Users/admin/Desktop/12.txt")
//解析一本书
kindle.parserBook(preFix: "搞定", clipPath: "/Users/admin/Desktop/My Clippings.txt")

