//
//  SKATMXParser.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/17/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation

let kMap = "map"
let kTileset = "tileset"
let kTile = "tile"
let kImage = "image"
let kLayer = "layer"
let kData = "data"

let kProperies = "properties"

class SKATMXParser : NSObject, NSXMLParserDelegate {
    
    enum ParsingMode{
       case None
       case TileSet
    }
    
    var parser = NSXMLParser()
    var mapDictionary = [String : AnyObject]()

    var tileSets = [[String: AnyObject]]()
    var tileSet = [String: AnyObject]()
    
    var tileID = ""
    var tiles = [[String: AnyObject]]()
    var tile = [String: AnyObject]()
    
    var layers = [[String: AnyObject]]()
    var layer = [String: AnyObject]()
    
    var data = [String : AnyObject]()
    
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
        

        switch elementName{
            case kMap :
                for (key, value) in attributeDict{
                    mapDictionary[key] = value
                }
            break
            
            case kTileset :
                tileSet = attributeDict
            break
            
            case kTile :
                
                if(tileID != ""){
                    print("THIS IS UNEXPECTED")
                }
                for (_, value) in attributeDict{
                    tileID = value
                }
            break
            
            case kImage :
                if(tileID != ""){
                    tile = [tileID : attributeDict]
                }
            break
            
            case kLayer :
                layer = attributeDict
            break
            
            case kData:
                data = attributeDict
            break
            

            
        default :
            print("unexpected name found: \(elementName)")
            break
        }
    
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if data.keys.count > 0{
            print("This will be fun: \(string)")
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch elementName{
            case kTileset:
                if(tiles.count > 0){
                    tileSet["tiles"] = tiles
                }
                tileSets.append(tileSet)
            break
            
            case kTile:
                tiles.append(tile)
                tileID = ""
            break
            
            case kLayer:
                layers.append(layer)
            break
            
            case kData:
                layer["data"] = data
                data = [String : AnyObject]()
            break
            
            
            
            default:
                break
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        mapDictionary["tilesets"] = tileSets
        mapDictionary["layers"] = layers
        print(mapDictionary)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}