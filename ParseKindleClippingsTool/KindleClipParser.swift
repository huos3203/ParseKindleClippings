//
//  KindleClipParser.swift
//  ParseKindleClippings
//
//  Created by huoshuguang on 2017/5/29.
//  Copyright © 2017年 huoshuguang. All rights reserved.
//

import Cocoa

class KindleClipParser: NSObject
{
    func ParserLrcWithPath(lrcFilePath:String)
    {
        var bookArray:[Book] = []
        var tmpBook = Book.init(name: "")
        let clipText = try! String.init(contentsOfFile: lrcFilePath)
        //通过 ======  划分组
        let clipArray:NSArray = (clipText as NSString).components(separatedBy: "==========") as NSArray
        clipArray.enumerateObjects(using: { (object, index, stop) in
            
            let lineArray:NSArray = (object as! NSString).components(separatedBy: "\n") as NSArray

            var bookname = ""
            var location = ""
            var start = ""
            var end = ""
            var content = ""
            lineArray.enumerateObjects({ (line, index, stop) in
                
                let linetext = line as! String
                switch index
                {
                case 1:
                    bookname = linetext
                case 2:
                    if(!linetext.isEmpty)
                    {
                        location = parseLine(linetext: linetext,
                                             regexStr: "(\\d{1,}-\\d{1,})|(\\d{1,})")
                        
                        if(linetext.contains("标注"))
                        {
                            let loca = location.components(separatedBy: "-")
                            if(loca.count > 1)
                            {
                                start = loca[0]
                                end = loca[1]
                            }
                        }
                    }
                case 4:
                    content = linetext
                default:
                    print("空行")
                }
            })
            
            if(tmpBook.name.isEmpty || tmpBook.name != bookname)
            {
                //新建书籍
                if(!bookname.isEmpty)
                {
                    tmpBook = Book.init(name: bookname)
                    bookArray.append(tmpBook)
                }
                
            }
            
            //向正在处理书籍中添加章节
            if(start != "")
            {
                let mark = Mark.init(start: start, end: end, time: "", content: content)
                tmpBook.marks.append(mark)
            }
            else
            {
                let note = Note.init(locationID: location, time: "", content: content)
                tmpBook.notes.append(note)
            }
        })
        
        print("几本：\(bookArray.count) 书名：\(bookArray[0].name)")
        
    }
    
    func parseLine(linetext:String, regexStr:String) -> String
    {
        let regex = try! NSRegularExpression.init(pattern: regexStr, options: NSRegularExpression.Options.caseInsensitive)
        let locaRange = regex.rangeOfFirstMatch(in: linetext,
                                                options:  NSRegularExpression.MatchingOptions.withTransparentBounds,
                                                range: NSMakeRange(0, linetext.utf16.count))
        return (linetext as NSString).substring(with: locaRange)
    }
}
