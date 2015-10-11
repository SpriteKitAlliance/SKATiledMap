//
//  SKATiledMap.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

class SKATiledMap : SKNode{

    /**
     Number of columns for the map
     */
    var mapWidth : Int
    
    /**
     Number of rows for the map
     */
    var mapHeight : Int
    
    /**
     Width of a single tile
     */
    var tileWidth : Int
    
    /**
     Height of a single tile
     */
    var tileHeight : Int
    
    /**
     returns an array of SKASpriteLayers
     */
    var spriteLayers = [SKASpriteLayer]()
    
    /**
     returns an array of SKAObjectLayers
     */
    var objectLayers = [SKAObjectLayer]()

    var mapProperties = [String : AnyObject]()
    
    var autoFollowNode : SKNode?
    
    /**
     Culling
     */

    var culledBefore = false
    var visibleArray = [SKASprite]()
    var lastY = 0
    var lastX = 0
    var lastWidth = 0
    var lastHeight = 0
    
    init(mapName: String){
        
        mapWidth = 0
        mapHeight = 0
        tileWidth = 0
        tileHeight = 0
        
        super.init()
        
        loadFile(mapName)
        
    }
    
    func loadFile(fileName: String)
    {
        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "tmx"){
            print("Sorry TMX files are not supported yet \(filePath)")
            return
        }
        else
        {
            if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json"){
                mapDictionaryForJSONFile(filePath)
            }

        }
    }
    
    func mapDictionaryForJSONFile(filePath : String){
        
        do{
            let JSONData = try NSData(contentsOfFile: filePath, options: .DataReadingMappedIfSafe)
            
            if (JSONData.length > 0)
            {
                do{
                    let mapDictionary = try NSJSONSerialization.JSONObjectWithData(JSONData, options:.AllowFragments) as! [String:AnyObject]
                    loadMap(mapDictionary)
                }
                catch
                {
                    
                }
            }

        }
        catch
        {
            
        }
    }
    
    
    func loadMap(mapDictionary : [String : AnyObject]){

        mapProperties = mapDictionary["properties"] as! [String : AnyObject]
        
        mapWidth = mapDictionary["width"] as! Int
        mapHeight = mapDictionary["height"] as! Int
        tileWidth = mapDictionary["tilewidth"] as! Int
        tileHeight = mapDictionary["tileheight"] as! Int
        
        var mapTiles = [String : SKAMapTile]()
        
        let tileSets = mapDictionary["tilesets"] as! [AnyObject]
        
        for (_, element) in tileSets.enumerate() {
            

            let tileSet = element as! [String : AnyObject]
            let tilesetProperties = tileSet["tileProperties"] as? [String: AnyObject]

            let tileWidth = tileSet["tilewidth"] as! Int
            let tileHeight = tileSet["tileheight"] as! Int
            
            //would like to figure out a better way to get that
            if let path = tileSet["image"] as? NSString{
                
                let component = path.lastPathComponent as NSString
                let imageName = component.stringByDeletingPathExtension
                let imageExtension = component.pathExtension
                
                var textureImage : UIImage?
                
                if let image = UIImage(named: imageName){
                    textureImage = image
                }
                else
                {
                    if let filePath = NSBundle.mainBundle().pathForResource(imageName, ofType: imageExtension){
                        
                        textureImage = UIImage(contentsOfFile: filePath)

                    }
                }
                
                
                if (textureImage != nil) {
                
                    let mainTexture = SKTexture(image: textureImage!)
                    mainTexture.filteringMode = .Nearest
                    
                    //working on small texture
                    let imageWidth = tileSet["imagewidth"] as! Int
                    let imageHeight = tileSet["imageheight"] as! Int
                    
                    let spacing = tileSet["spacing"] as! Int
                    let margin = tileSet["margin"] as! Int
                    
                    let width = imageWidth - (margin * 2)
                    let height = imageHeight - (margin * 2)
                    
                    let tileColumns : Int = Int(ceil(Float(width) / Float(tileWidth + spacing)))
                    let tileRows : Int = Int(ceil(Float(height) / Float(tileHeight + spacing)))
                    
                    let spacingPercentWidth : Float = Float(spacing)/Float(imageWidth)
                    let spacingPercentHeight : Float = Float(spacing)/Float(imageHeight)
                    
                    let marginPercentWidth : Float = Float(margin) / Float(tileWidth)
                    let marginPercentHeight : Float = Float(margin) / Float(tileHeight)
                    
                    let tileWidthPercent : Float = Float (tileWidth) / Float(imageWidth)
                    let tileHeightPercent : Float = Float (tileHeight) / Float(imageHeight)
                    
                    let firstIndex = tileSet["firstgid"] as! Int
                    var index = firstIndex
                    
                    let tilesetProperties = tileSet["tileProperties"] as? [String: AnyObject]
                    
                    for var rowID = 0; rowID < tileRows; ++rowID{
                        
                        for var columnID = 0; columnID < tileColumns; ++columnID{
                            
                            let x = CGFloat(marginPercentWidth + Float(columnID) * Float(tileWidthPercent + spacingPercentWidth)); // advance based on column
                            
                            let yOffset = Float(marginPercentHeight + tileHeightPercent)
                            let yTileHeight = Float(tileHeightPercent + spacingPercentHeight)
                            
                            let y = CGFloat(1.0 - (yOffset + (Float(rowID) * yTileHeight))) //advance based on row
                            
                            
                            let texture = SKTexture(rect: CGRectMake(x, y, CGFloat(tileWidthPercent), CGFloat(tileHeightPercent)), inTexture: mainTexture)
                            
                            texture.filteringMode = .Nearest
                            
                            let mapTile = SKAMapTile(texture: texture)
                            
                            let propertiesKey = String(index-firstIndex)
                            
                            if (tilesetProperties != nil) {
                                
                                if let tileProperties = tilesetProperties![propertiesKey] as? [String : AnyObject]{
                                    mapTile.properties = tileProperties
                                }
                                
                            }
                            
                            mapTiles[String(index)] = mapTile
                            index++;
                        }
                    }

                }
                else
                {
                    print("It appears Image:\(component) is missing")
                    return;
                }
            }
            
            if let collectionTiles = tileSet["tiles"] as? [String : AnyObject]
            {
                
                let firstIndex = tileSet["firstgid"] as! Int

                for (key, spriteDict) in collectionTiles{
                    
                    if let dict = spriteDict as? [String : AnyObject]{
                        
                        var imageName : NSString?
                        
                        if let imagePath = dict["image"] as? NSString{
                            
                            imageName = imagePath.lastPathComponent
                        }
                        
                        if let imagePath = dict["source"] as? NSString{
                            
                            imageName = imagePath.lastPathComponent
                        }
                        
                        if (imageName != nil) {
                            let texture = SKTexture(imageNamed: (imageName?.stringByDeletingPathExtension)!)
                            texture.filteringMode = .Nearest
                            
                            let index = Int(key)! + firstIndex
                            
                            let propertiesKey = String(firstIndex-index)
                            
                            let mapTile = SKAMapTile(texture: texture)
                            
                            if (tilesetProperties != nil) {
                                
                                if let tileProperties = tilesetProperties![propertiesKey] as? [String : AnyObject]{
                                    mapTile.properties = tileProperties
                                }
                                
                            }
                            
                            mapTiles[String(index)] = mapTile
                        }
                    }
                }
            }
        }
        
        var layerNumber = 0
        
        if let layers = mapDictionary["layers"] as? [AnyObject]{
            
            for layer  in layers {
                
                if let layerDictionary = layer as? [String : AnyObject] {
                    if let tileIDs = layerDictionary["data"] as? [Int]{
                    
                        let spriteLayer = SKASpriteLayer(properties: layerDictionary)
                        
                        var rowArray = [[Int]]()
                        
                        var rangeStart = 0
                        let rangeLength = mapWidth-1
                        
                        for var index = 0; index < mapHeight; ++index{
                            rangeStart = tileIDs.count - ((index + 1) * mapWidth )
                            
                            let row : [Int] = Array(tileIDs[rangeStart...rangeStart+rangeLength])
                            rowArray.append(row)
                        }
                        
                        var sprites = [[SKASprite?]]()
                        
                        for var i = 0; i < self.mapWidth; ++i{
                            
                            var column = [SKASprite?]()
                            for var j = 0; j < self.mapHeight; ++j{
                                column.append(SKASprite())
                            }
                            
                            sprites.append(column)
                        }
                        
                        //adding sprites
                        for (rowIndex, row) in rowArray.enumerate(){
                            
                            for (columnIndex, number) in row.enumerate(){
                                let key = String(number)
                                if let mapTile = mapTiles[key]{
                                    
                                    let sprite = SKASprite(texture: mapTile.texture)
                                    
                                    //positioning
                                    let xOffset = Int(tileWidth / 2)
                                    let yOffset = Int(tileHeight / 2)
                                    let x = (Int(sprite.size.width / 2) - xOffset) + xOffset + columnIndex * tileWidth
                                    let y = (Int(sprite.size.height / 2) - yOffset) + yOffset + rowIndex * tileHeight
                                    sprite.position = CGPointMake(CGFloat(x), CGFloat(y))
                                    
                                    sprite.properties = mapTile.properties
                                    
                                    if  let properties = sprite.properties{
                                        if let collisionType = properties["SKACollsionType"]! as? String{
                                            if collisionType == "SKACollisionTypeRect"{
                                                sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
                                                sprite.physicsBody!.dynamic = false
//                                                sprite.physicsBody.categoryBitMask = SKACategoryFloor;
//                                                sprite.physicsBody.contactTestBitMask = SKACategoryPlayer;
                                                sprite.zPosition = 20;
                                            }
                                        }
                                    }
                                    
                                    spriteLayer.addChild(sprite)
                                    
                                    if(!spriteLayer.visible){
                                        sprite.hidden = true
                                    }
                                    
                                    sprites[columnIndex][rowIndex] = sprite
                                }
                            }
                        }
                        
                        spriteLayer.sprites = sprites
                        spriteLayer.zPosition = CGFloat(layerNumber)
                        addChild(spriteLayer)
                        spriteLayers.append(spriteLayer)
                        
                        layerNumber++
                    }
                    if let objectsArray = layerDictionary["objects"] as? [AnyObject]{
                        
                        let objectLayer = SKAObjectLayer(properties: layerDictionary)
                        var collisionSprites = [SKASprite]()
                        var objects = [SKAObject]()
                        
                        for objectDictionary in objectsArray{
                            
                            if let properties = objectDictionary as? [String : AnyObject]{
                                
                                let object = SKAObject(properties: properties)
                                
                                if(objectLayer.drawOrder == "topdown")
                                {
                                    object.y = (mapHeight * tileHeight) - object.y - object.height;
                                }
                                
                                if let objectProperties = object.properties{
                                    if let collisionType = objectProperties["SKACollisionType"] as? String{
                                        if collisionType == "SKACollisionTypeRect"{
                                            
                                            let floorSprite = SKASprite(color: SKColor.clearColor(), size: CGSizeMake(CGFloat(object.width), CGFloat(object.height)))
                                            floorSprite.zPosition = CGFloat(layerNumber)
                                            let centerX = CGFloat(object.x+object.width/2)
                                            let centerY = CGFloat(object.y+object.height/2)
                                            floorSprite.position = CGPointMake(centerX, centerY)
                                            floorSprite.physicsBody = SKPhysicsBody(rectangleOfSize: floorSprite.size)
                                            floorSprite.physicsBody?.dynamic = false
                                            //floorSprite.physicsBody.categoryBitMask = SKACategoryFloor;
                                            //floorSprite.physicsBody.contactTestBitMask = SKACategoryPlayer;
                                            addChild(floorSprite)
                                            collisionSprites.append(floorSprite)
                                        }
                                    }
                                }
                                
                                objects.append(object)
                            }
                        }
                        
                        objectLayer.collisionSprites = collisionSprites;
                        
                        objectLayer.objects = objects;
                        objectLayers.append(objectLayer)
                        layerNumber++;
                    }
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func index(point : CGPoint){
        
    }
    
    func tilesAround(point : CGPoint)-> [SKASprite?]{
        return [SKASprite]()
    }
    
    func tileAround(index : CGPoint) -> [SKASprite?]{
        return [SKASprite]()
    }
    
    func sprite(layer : Int, x : Int, y : Int) -> SKASprite{
        return SKASprite()
    }
    
}