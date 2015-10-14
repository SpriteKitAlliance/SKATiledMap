//
//  SKATiledMap.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

/**
 Enum used to define collision for auto generated physics feature
*/
enum SKAColliderType: UInt32 {
    case Player = 1
    case Floor = 2
    case Wall = 4
}

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

    /**
     Additional properties found on the map
     */
    var mapProperties = [String : AnyObject]()
    
    /**
     Used for moving the map based on the position of a child node
     */
    var autoFollowNode : SKNode?
    
    /**
     Culling logic
     */
    var culledBefore = false
    var visibleArray = [SKASprite]()
    var lastY = 0
    var lastX = 0
    var lastWidth = 0
    var lastHeight = 0
    
    /**
     Designated Initializer
     @param mapName name of the map you want. No need for file extension
     */
    init(mapName: String){
        
        mapWidth = 0
        mapHeight = 0
        tileWidth = 0
        tileHeight = 0
        
        super.init()
        
        loadFile(mapName)
    }
    
    /**
     Looks for tmx or json file based on a map name and loads map data
     @param fileName the name of the map without a file extension
     */
    func loadFile(fileName: String)
    {
        //checks for tmx first then trys json if a tmx file can not be found
        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "tmx"){
            //currently tmx files are not supported but will be in the near future
            print("Sorry TMX files are not supported yet \(filePath)")
            return
        }
        else
        {
            //looks for tmx file
            if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json"){
                mapDictionaryForJSONFile(filePath)
            }

        }
    }
    
    /**
     Creates the key value pair needed for map creation based on json file
     @param filePath the path to the JSON file
     */
    func mapDictionaryForJSONFile(filePath : String){
        
        //attemps to return convert json file over to a key value pairs
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
                    print("Unable to convert \(filePath) to a key value object")
                }
            }
        }
        catch
        {
            print("Unable to load \(filePath) as NSData")
        }
    }
    
    // MARK: - private class functions
    /**
     Generates a map based on pre determined keys and values
     @param mapDictionary the key value set that originated from a tmx or json file
     */
    private func loadMap(mapDictionary : [String : AnyObject]){

        //getting additional user generated properties for map
        guard let _ = mapDictionary["properties"] as? [String : AnyObject] else {
            print("Error: Map is missing properties values")
            return
        }
        mapProperties = mapDictionary["properties"] as! [String : AnyObject]
        
        //getting value that determines how many tiles wide the map is
        guard let _ = mapDictionary["width"] as? Int else {
            print("Error: Map is missing width value")
            return
        }
        mapWidth = mapDictionary["width"] as! Int
        
        //getting value that determines how many tiles tall a map is
        guard let _ = mapDictionary["height"] as? Int else {
            print("Error: Map is missing height value")
            return
        }
        mapHeight = mapDictionary["height"] as! Int
        
        //getting value that determines the width of a tile
        guard let _ = mapDictionary["tilewidth"] as? Int else {
            print("Error: Map is missing width value")
            return
        }
        tileWidth = mapDictionary["tilewidth"] as! Int
        
        //getting value that determines the height of a tile
        guard let _ = mapDictionary["tileheight"] as? Int else {
            print("Error: Map is missing width value")
            return
        }
        tileHeight = mapDictionary["tileheight"] as! Int
        
        var mapTiles = [String : SKAMapTile]()
        
        guard let tileSets = mapDictionary["tilesets"] as? [AnyObject] else{
            print("Map is missing tile sets to generate map")
            return
        }
        
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
                        
                        var sprites = [[SKASprite]]()
                        
                        for var i = 0; i < self.mapWidth; ++i{
                            
                            var column = [SKASprite]()
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
                                                sprite.physicsBody!.categoryBitMask = SKAColliderType.Floor.rawValue;
                                                sprite.physicsBody!.contactTestBitMask = SKAColliderType.Player.rawValue;
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
                                            floorSprite.physicsBody!.categoryBitMask = SKAColliderType.Floor.rawValue;
                                            floorSprite.physicsBody!.contactTestBitMask = SKAColliderType.Player.rawValue;
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
    
    /**
     Used to update map position if autoFollowNode is set
     */
    func update(){
        
        if (autoFollowNode != nil && scene?.view != nil)
        {
            position = CGPointMake(
                -autoFollowNode!.position.x + scene!.size.width / 2,
                -autoFollowNode!.position.y + scene!.size.height / 2);
            
            /*
            * Check position of the minimap and stop it from going off screen
            */
            var tempPosition = position;
            
            if(tempPosition.x > 0)
            {
                tempPosition.x = 0;
            }
            
            if(tempPosition.y > 0)
            {
                tempPosition.y = 0;
            }
            
            if(tempPosition.y < -CGFloat(mapHeight * tileHeight) + scene!.size.height){
                tempPosition.y = -CGFloat(mapHeight * tileHeight) + scene!.size.height
            }
            if(tempPosition.x < -CGFloat(mapWidth * tileWidth) + scene!.size.width){
                tempPosition.x = -CGFloat(mapWidth * tileWidth) + scene!.size.width
            }
            
            //shound round to whole numbers
            position = tempPosition
        }
    }
    
    /**
     Culling "hiding" nodes that do not need to be rendered greatly improves performace and frame rate.
     This method is optimized to be called every update loop
     @param x the center x index you wish to cull around
     @param y the center y index you wish to cull around
     @param width the number of tiles wide you would like to keep
     @param height the number of tiles high you would like to keep
     */
    func cullAround(x : Int, y : Int, width : Int, height : Int){
        
        if(!culledBefore)
        {
            for var layerIndex = 0; layerIndex < spriteLayers.count; ++layerIndex{
                for var xIndex = 0; xIndex < mapWidth; ++xIndex{
                    for var yIndex = 0; yIndex < mapHeight; ++yIndex{
                        let sprite = spriteFor(layerIndex, x: xIndex, y: yIndex)
                        sprite.hidden = true
                    }
                }
            }
        }
        
        if(lastX != x || lastY != y || lastWidth != width || lastHeight != height){
            
            for vSprite in visibleArray{
                vSprite.hidden = true
            }
            
            // calculate what to make visiable
            visibleArray = [SKASprite]()
            
            var startingX = x - width / 2
            var startingY = y - height / 2
            var endingX = startingX + width
            var endingY = startingY + height
            
            if(startingX < 0){
                startingX = 0
                endingX = width
            }
            
            if(startingY < 0){
                startingY = 0
                endingY = height
            }
            
            if(endingX >= mapWidth){
                endingX = mapWidth
                startingX = endingX - width
            }
            
            if (endingY >= mapHeight){
                endingY = mapHeight
                startingY = endingY - height
            }
            
            if(startingX < 0){
                startingX = 0
            }
            
            if(startingY < 0){
                startingY = 0
            }
            
            if(endingX < 0){
                endingX = 0
            }
            
            if(endingY < 0){
                endingY = 0
            }
            
            for var layerIndex = 0; layerIndex < spriteLayers.count; ++layerIndex{
                for var xIndex = startingX; xIndex < endingX; ++xIndex{
                    for var yIndex = startingY; yIndex < endingY; ++yIndex{
                        let sprite = spriteFor(layerIndex, x: xIndex, y: yIndex)
                        sprite.hidden = false
                        visibleArray.append(sprite)
                    }
                }
            }
            
            lastX = x
            lastY = y
            lastWidth = width
            lastHeight = height
            
            culledBefore = true
            
        }
    }

    /**
     Returns a CGPoint that can be used as an x and y index
     @param point the point in which to calculate the index
     */
    func index(point : CGPoint) -> CGPoint{
        let x = Int(point.x)/tileWidth
        let y = Int(point.y)/tileHeight
        return CGPointMake(CGFloat(x), CGFloat(y));
    }
    
    /**
     Returns all the tiles around a specific index for a specific point. Very useful if you need to know
     about tiles around a specific index.
     @param index the CGPoint that will be used as a x and y index
     @param layerNumber the layer in which you would like your tiles
     */
    func tilesAround(index : CGPoint, layerNumber : Int)-> [SKASprite?]{
        
        let x = Int(index.x)
        let y = Int(index.y)
        
        var tiles = [SKASprite]()
        
        let layer = spriteLayers[layerNumber]
        
        if (x - 1 > 0){
            
            tiles.append(layer.sprites[x-1][y])
            
            if(y - 1 >= 0){
                tiles.append(layer.sprites[x-1][y-1])
            }
            
            if(y + 1 < self.mapHeight){
                tiles.append(layer.sprites[x-1][y+1])
            }
        }
        
        if (x + 1 < self.mapWidth){
            
            tiles.append(layer.sprites[x+1][y])
            
            if(y + 1 < self.mapHeight){
                tiles.append(layer.sprites[x+1][y+1])
            }
            
            if(y - 1 >= 0){
                tiles.append(layer.sprites[x+1][y-1])
            }
        }
        
        if (y - 1 >= 0)
        {
            tiles.append(layer.sprites[x][y-1])
        }
        
        if (y + 1 < mapHeight){
            tiles.append(layer.sprites[x][y+1])
        }
        
        return tiles
    }
    
    /**
     Convientent method to quickly get a specific tile for a specific layer on the map
     @param layerNumber the layer in which you would like to use
     @param x the x index to use
     @param y the y index to use
     */
    func spriteFor(layerNumber : Int, x : Int, y : Int) -> SKASprite{
        let layer = spriteLayers[layerNumber]
        let sprite = layer.sprites[x][y]
        return sprite
    }
    
    /**
    Lame required function for subclassing
    */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}