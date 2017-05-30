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
    var bookArray:[Book] = []
    var tmpBook = Book.init(name: "")
    
    ///仅解析一本书：使用书名组合正则来匹配一本书
    func parserBook(preFix:String = "",clipPath:String)
    {
        //
        let clipText = try! String.init(contentsOfFile: clipPath)
        let clipArray:NSArray = parseBook(clippings: clipText, booknamePrefix: preFix) as NSArray
        clipArray.enumerateObjects(using: { (cell, index, stop) in
//            print("\(cell)")
            parseNoteCell(celltext: (cell as! String))
        })
        print("几本：\(bookArray.count) 书名：\(bookArray[0].name)")
    }
    
    ///解析所有的书：直接使用"=========="分割
    func ParserLrcWithPath(lrcFilePath:String)
    {
        
        let clipText = try! String.init(contentsOfFile: lrcFilePath)
        //通过 ======  划分组
        let clipArray:NSArray = (clipText as NSString).components(separatedBy: "==========") as NSArray
        //解析mark／note部分
        clipArray.enumerateObjects(using: { (cell, index, stop) in
            
            parseMarkCell(celltext: (cell as! String))
        })
        
        print("几本：\(bookArray.count) 书名：\(bookArray[0].name)")
        
    }
    
    func parseBook(clippings:String,booknamePrefix:String)->[String]
    {
        var results:[String] = []
        let bookregex = "\(booknamePrefix)[^==========]*=========="
        let regex = try! NSRegularExpression.init(pattern: bookregex, options: .allowCommentsAndWhitespace)
        regex.enumerateMatches(in: clippings, options: .init(rawValue: 0), range: NSMakeRange(0, clippings.utf16.count)) { (regexResult, flags, stop) in
            //
            let bookRange = regexResult?.rangeAt(0)
            let bookStr = (clippings as NSString).substring(with: bookRange!)
            results.append(bookStr)
        }
        return results
    }
    
    func parseLine(linetext:String, regexStr:String) -> String
    {
        let regex = try! NSRegularExpression.init(pattern: regexStr, options: NSRegularExpression.Options.caseInsensitive)
        let locaRange = regex.rangeOfFirstMatch(in: linetext,
                                                options:  NSRegularExpression.MatchingOptions.withTransparentBounds,
                                                range: NSMakeRange(0, linetext.utf16.count))
        return (linetext as NSString).substring(with: locaRange)
    }
    
    
    func parseMarkCell(celltext:String)
    {
        
        var bookname = ""
        var location = ""
        var start = ""
        var end = ""
        var content = ""
        let lineArray:NSArray = celltext.components(separatedBy: "\n") as NSArray
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
    }
    
    func parseNoteCell(celltext:String)
    {
        
        var bookname = ""
        var location = ""
        var start = ""
        var end = ""
        var content = ""
        let lineArray = celltext.components(separatedBy: "\r\n")
        
        /**/
        if lineArray.count != 5
        {
            return
        }
         (lineArray as NSArray).enumerateObjects({ (line, index, stop) in
            
            let linetext = line as! String
            switch index
            {
            case 0:  //书名
                bookname = linetext
            case 1:   //位置
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
            case 3:  //笔记
                content = linetext
            default:
                _ = ""
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
    }
}
