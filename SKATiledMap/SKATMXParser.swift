//
//  SKATMXParser.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/17/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation

let kMap = "map"
let kProperies = "properties"

class SKATMXParser : NSObject, NSXMLParserDelegate {
    
    var parser = NSXMLParser()
    var elements = [String : AnyObject]()
    var elementName = String()
    
    init(filePath : String){
        
        super.init()
        //attemps to return convert json file over to a key value pairs
        do{
            let tmxData = try NSData(contentsOfFile: filePath, options: .DataReadingMappedIfSafe)
            
            if (tmxData.length > 0)
            {
                parser = NSXMLParser(data: tmxData)
            }
            else{
                fatalError("Unable to load tmx file: \(filePath)")
            }
        }
        catch
        {
            fatalError("Unable to load tmx file: \(filePath)")
        }
        
        parser.delegate = self
        parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        self.elementName = elementName

        switch elementName{
            case kMap :
                //TODO parse instead of resetting just in case we don't get it first
                elements = attributeDict
                print(elements)
            break
            
        default :
            print("unexpected name found: \(elementName)")
            break
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}