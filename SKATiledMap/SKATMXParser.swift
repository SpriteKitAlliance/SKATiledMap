//
//  SKATMXParser.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/17/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation

class SKATMXParser : NSObject, NSXMLParserDelegate {
    
    //MARK: - Public Properties
    var parser = NSXMLParser()
    var mapDictionary = ["properties" : [String: AnyObject]()] as [String : AnyObject]
    
    //MARK: - Private Properties
    /**
     Parsing keys
     */
    private let kMap = "map"
    private let kTileset = "tileset"
    private let kTile = "tile"
    private let kImage = "image"
    private let kLayer = "layer"
    private let kData = "data"
    private let kObjectGroup = "objectgroup"
    private let kObject = "object"
    private let kProperty = "property"
    private let kProperies = "properties"

    /**
     Data holders for tile sets
     */
    private var tileSets = [[String: AnyObject]]()
    private var tileSet = [String: AnyObject]()
    
    /**
     Data holders for tile information
     */
    private var tileID = ""
    private var tiles = [String: AnyObject]()
    private var tile = [String: AnyObject]()
    
    /**
     Data holders layer information
     */
    private var layers = [[String: AnyObject]]()
    private var layer = [String: AnyObject]()
    private var data = [String : AnyObject]()
    
    /**
     Dataholders for object layers
     */
    private var objectLayers = [[String: AnyObject]]()
    private var objectLayer = [String: AnyObject]()
    
    /**
     Dataholders for objects
     */
    private var objects = [[String: AnyObject]]()
    private var object = [String: AnyObject]()
    var properties = [String: AnyObject]()
    
    
    //MARK: - Initializers
    /**
    Designated Initializer
    @param filePath used to locate tmx file
    */
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
                tileSet = newTileset()
                for (key, value) in attributeDict{
                    tileSet[key] = value
                }

                tiles = [String : AnyObject]()
            break
            
            case kTile :
                for (_, value) in attributeDict{
                    tileID = value
                }
            break
            
            case kImage :
                if(tileID != ""){
                    tile = attributeDict
                }
                else{
                    for (key, value) in attributeDict{
                        if key == "width" {
                            tileSet["imagewidth"] = value
                        }
                        else if key == "height"{
                            tileSet["imageheight"] = value
                        }
                        else{
                            tileSet[key] = value
                        }
                    }
                }
            break
            
            case kLayer :
                layer = newSpriteLayer()
                for (key, value) in attributeDict{
                    layer[key] = value
                }
            break
            
            case kData:
                data = attributeDict
            break
            
            case kObjectGroup :
                objectLayer = newObjectLayer()
                for (key, value) in attributeDict{
                    objectLayer[key] = value
                }
            break
            
            case kObject :
                object = newObject()
                for (key, value) in attributeDict{
                    object[key] = value
                }
            break
            
            case kProperty:
                if let key = attributeDict["name"]{
                    if let value = attributeDict["value"]{
                        properties[key] = value
                    }
                }
            break
            
            case kProperies:
                properties = [String: AnyObject]()
            break
            
        default :
            print("unexpected name found: \(elementName)\nAttr: \(attributeDict)")
            break
        }
    
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if data.keys.count > 0{
            if data["encoding"] as? String == "csv"{
                let numberString = string.stringByReplacingOccurrencesOfString("\n", withString: "")
                let numbers = numberString.componentsSeparatedByString(",")
                
                var tileIDs = [Int]()
                
                for number in numbers{
                    tileIDs.append(Int(number)!)
                }
                layer["data"] = tileIDs
            }
            else{
                fatalError("Error: tmx only support csv layer format. Before saving tmx go to Map->Map Options->Map->Tile Layer Format and chaning to csv")
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch elementName{
            case kTileset:
                if(tiles.count > 0){
                    tileSet["tiles"] = tiles
                }
                tileSets.append(cleanDictionary(tileSet))
            break
            
            case kTile:
                tiles[tileID] = (cleanDictionary(tile))
                tileID = ""
            break
            
            case kLayer:
                layers.append(cleanDictionary(layer))
            break
            
            case kData:
                data = [String : AnyObject]()
            break
            
            case kObject:
                objects.append(cleanDictionary(object))
            break
            
            case kObjectGroup:
                objectLayer["objects"] = objects
                layers.append(objectLayer)
            break
            
            case kProperies:
                object["properties"] = properties
            break
            
            default:
                break
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        mapDictionary["tilesets"] = tileSets
        mapDictionary["layers"] = layers
        print(mapDictionary)
        
        mapDictionary = cleanDictionary(mapDictionary)
    }
    
    func newObject() -> [String: AnyObject]{
        return ["x": "0", "y": "0", "width": "0", "height": "0", "type": "", "name": "pizza", "rotation": 0.0, "visible": true]
    }
    
    func newObjectLayer() -> [String: AnyObject]{
        return ["x": 0, "y": 0, "width": 0, "height": 0, "type": "", "name": "", "opacity": 0.0, "visible": true, "draworder": "topdown"]
    }
    
    func newSpriteLayer() -> [String: AnyObject]{
        return ["x": 0, "y": 0, "width": 0, "height": 0, "type": "", "name": "", "opacity": 0.0, "visible": true, "draworder": "topdown"]
    }
    
    func newTileset() -> [String : AnyObject]{
        return ["spacing": 0, "margin": 0];
    }
    
    func cleanDictionary(dictionary: [String : AnyObject]) -> [String : AnyObject] {
        var dictCopy = dictionary
        let intTypes = ["width", "height", "x", "y", "tilewidth", "tileheight", "firstgid", "imagewidth", "imageheight", "spacing", "margin"]
        let floatTypes = ["opacity", "rotation"]
        let boolTypes = ["visible"]
        
        for (key, value) in dictionary where value is String{
            //clean expected Ints
            for intType in intTypes where intType == key {
                dictCopy[key] = Int(Float(value as! String)!)
            }
            for floatType in floatTypes where floatType == key {
                dictCopy[key] = Float(value as! String)
            }
            for boolType in boolTypes where boolType == key {
                dictCopy[key] = Int(value as! String) == 1
            }
        }
        
        if let image = dictCopy["source"] as? String{
            dictCopy["image"] = image
            dictCopy["source"] = nil
        }
        
        return dictCopy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}