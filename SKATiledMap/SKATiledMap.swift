//
//  SKATiledMap.swift
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

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

    //MARK: - Public Properties
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
    
    //MARK: - Private Properties
    /**
     Culling logic
     */
    private var culledBefore = false
    private var visibleArray = [SKASprite]()
    private var lastY = 0
    private var lastX = 0
    private var lastWidth = 0
    private var lastHeight = 0
    
    var tmxParser : SKATMXParser?
    
    //MARK: - Initializers
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
    
    //MARK: - Public Functions
    /**
     Looks for tmx or json file based on a map name and loads map data
     @param fileName the name of the map without a file extension
     */
    func loadFile(fileName: String)
    {
        //checks for tmx first then trys json if a tmx file can not be found
        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "tmx"){
            tmxParser = SKATMXParser(filePath:filePath)
            loadMap((tmxParser?.mapDictionary)!)
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
    Used to update map position if autoFollowNode is set
    */
    func update(){
        
        if (autoFollowNode != nil && scene?.view != nil)
        {
            position = CGPointMake(
                -autoFollowNode!.position.x + scene!.size.width / 2,
                -autoFollowNode!.position.y + scene!.size.height / 2);
            
            //check position of the minimap and stop it from going off screen
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
            for layerIndex in 0 ..< spriteLayers.count{
                for xIndex in 0 ..< mapWidth{
                    for yIndex in 0 ..< mapHeight{
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
            
            //preventing trying to unhide sprites off map
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
            
            //un hiding sprites that need to be rendered
            for layerIndex in 0 ..< spriteLayers.count{
                for xIndex in startingX ..< endingX{
                    for yIndex in startingY ..< endingY{
                        let sprite = spriteFor(layerIndex, x: xIndex, y: yIndex)
                        sprite.hidden = false
                        visibleArray.append(sprite)
                    }
                }
            }
            
            //storing values to optimize culling during update
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
     This method is used to get custom named objects that you may have made in Tiled 
     for spawning enemies, player start positions, or any other custom game logic you 
     made a object for.
     */
    func objectsOn(layerNumber: Int, name: String) -> [SKAObject]?{
        let objects = objectLayers[layerNumber].objects
        return  objects.filter({$0.name == name})
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
        
        //grabbring sprites but checking to make sure it isn't trying to grab outside map bounds
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

    
    // MARK: - Private Class Functions
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
    
    /**
     Generates a map based on pre determined keys and values
     @param mapDictionary the key value set that originated from a tmx or json file
     */
    private func loadMap(mapDictionary : [String : AnyObject]){

        //getting additional user generated properties for map
        guard let _ = mapDictionary["properties"] as? [String : AnyObject] else {
            fatalError("Error: Map is missing properties values")
        }
        mapProperties = mapDictionary["properties"] as! [String : AnyObject]
        
        //getting value that determines how many tiles wide the map is
        guard let _ = mapDictionary["width"] as? Int else {
            fatalError("Error: Map is missing width value")
        }
        mapWidth = mapDictionary["width"] as! Int
        
        //getting value that determines how many tiles tall a map is
        guard let _ = mapDictionary["height"] as? Int else {
            fatalError("Error: Map is missing height value")
        }
        mapHeight = mapDictionary["height"] as! Int
        
        //getting value that determines the width of a tile
        guard let _ = mapDictionary["tilewidth"] as? Int else {
            fatalError("Error: Map is missing width value")
        }
        tileWidth = mapDictionary["tilewidth"] as! Int
        
        //getting value that determines the height of a tile
        guard let _ = mapDictionary["tileheight"] as? Int else {
            fatalError("Error: Map is missing width value")
        }
        tileHeight = mapDictionary["tileheight"] as! Int
        
        var mapTiles = [String : SKAMapTile]()
        
        guard let tileSets = mapDictionary["tilesets"] as? [AnyObject] else{
            fatalError("Map is missing tile sets to generate map")
        }
        
        //setting up all tile set layers
        for (_, element) in tileSets.enumerate() {
            
            guard let tileSet = element as? [String : AnyObject] else{
                fatalError("Error: tile sets are not properly formatted")
            }
            
            let tilesetProperties = tileSet["tileproperties"] as? [String: AnyObject]

            guard let tileWidth = tileSet["tilewidth"] as? Int else{
                fatalError("Error: tile width for tile set isn't set propertly")
            }
            
            guard let tileHeight = tileSet["tileheight"] as? Int else{
                fatalError("Error: tile width for tile set isn't set propertly")
            }
            
            //determining if we have a sprite sheet
            if let path = tileSet["image"] as? NSString{
                
                //parsing out the image name
                let component = path.lastPathComponent as NSString
                let imageName = component.stringByDeletingPathExtension
                let imageExtension = component.pathExtension
                
                var textureImage : UIImage?
                
                //first trying to get the image without absolute path
                if let image = UIImage(named: imageName){
                    textureImage = image
                }
                else
                {
                    //resorting to absolute path if reference folders are used
                    if let filePath = NSBundle.mainBundle().pathForResource(imageName, ofType: imageExtension){
                        
                        textureImage = UIImage(contentsOfFile: filePath)
                    }else{
                        print("Error: missing image: \(imageName)")
                    }
                }
                
                //creating smaller textures from big texture
                if (textureImage != nil) {
                
                    let mainTexture = SKTexture(image: textureImage!)
                    mainTexture.filteringMode = .Nearest
                    
                    //geting sprite sheet information
                    guard let imageWidth = tileSet["imagewidth"] as? Int else {
                        fatalError("Error: Image width is not set properly on tile sheet")
                    }
                    
                    guard let imageHeight = tileSet["imageheight"] as? Int else{
                        fatalError("Error: Image height is not set properly on tile sheet")
                    }
                    
                    guard let spacing = tileSet["spacing"] as? Int else{
                        fatalError("Error: Image spacing is not set properly on tile sheet")
                    }
                    
                    guard let margin = tileSet["margin"] as? Int else{
                        fatalError("Error: Image margin is not set properly on tile sheet")
                    }
                    
                    guard let firstIndex = tileSet["firstgid"] as? Int else{
                        fatalError("Error: Image firstgid is not set properly on tile sheet")
                    }

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
                    
                    var index = firstIndex
                    
                    let tilesetProperties = tileSet["tileproperties"] as? [String: AnyObject]
                    
                    for rowID in 0 ..< tileRows{
                        
                        for columnID in 0 ..< tileColumns{
                            
                            // advance based on column
                            let x = CGFloat(marginPercentWidth + Float(columnID) * Float(tileWidthPercent + spacingPercentWidth));
                            
                            //advance based on row
                            let yOffset = Float(marginPercentHeight + tileHeightPercent)
                            let yTileHeight = Float(tileHeightPercent + spacingPercentHeight)
                            let y = CGFloat(1.0 - (yOffset + (Float(rowID) * yTileHeight)))
                            
                            let texture = SKTexture(rect: CGRectMake(x, y, CGFloat(tileWidthPercent), CGFloat(tileHeightPercent)), inTexture: mainTexture)
                            
                            texture.filteringMode = .Nearest
                            
                            //creating mapTile object to store texture and sprite properties
                            let mapTile = SKAMapTile(texture: texture)
                            
                            let propertiesKey = String(index-firstIndex)
                            
                            if (tilesetProperties != nil && tilesetProperties?.count > 0) {
                                
                                if let tileProperties = tilesetProperties![propertiesKey] as? [String : AnyObject]{
                                    mapTile.properties = tileProperties
                                }
                                
                            }
                            
                            mapTiles[String(index)] = mapTile
                            index += 1;
                        }
                    }

                }
                else
                {
                    print("It appears Image:\(component) is missing")
                    return;
                }
            }
            
            //determining if we are working with image collection
            if let collectionTiles = tileSet["tiles"] as? [String : AnyObject]
            {
                
                guard let firstIndex = tileSet["firstgid"] as? Int else{
                    fatalError("Error: Image firstgid is not set properly on tile sheet")
                }

                for (key, spriteDict) in collectionTiles{
                    
                    if let dict = spriteDict as? [String : AnyObject]{
                        
                        //getting image name to be used in texture
                        var imageName : NSString?
                        
                        if let imagePath = dict["image"] as? NSString{
                            
                            imageName = imagePath.lastPathComponent
                        }
                        
                        if let imagePath = dict["source"] as? NSString{
                            
                            imageName = imagePath.lastPathComponent
                        }
                        
                        if (imageName != nil) {
                            
                            //creating mapTile object to store texture and sprite properties
                            let texture = SKTexture(imageNamed: (imageName!.stringByDeletingPathExtension))
                            texture.filteringMode = .Nearest
                            
                            let index = Int(key)! + firstIndex
                            
                            let mapTile = SKAMapTile(texture: texture)
                            mapTile.properties = dict
                            
                            if (tilesetProperties != nil && tilesetProperties?.count > 0) {
                                
                                if let tileProperties = tilesetProperties![key] as? [String : AnyObject]{
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
        
        //generating layers
        if let layers = mapDictionary["layers"] as? [AnyObject]{
            
            for layer  in layers {
                if let layerDictionary = layer as? [String : AnyObject] {
                    
                    //determining if we are working with a sprite layer
                    if let tileIDs = layerDictionary["data"] as? [Int]{
                    
                        //creating a sprite layer to hold all sprites for that layer
                        let spriteLayer = SKASpriteLayer(properties: layerDictionary)
                        
                        //sorting tile ids in the correct order
                        var rowArray = [[Int]]()
                        
                        var rangeStart = 0
                        let rangeLength = mapWidth-1
                        
                        for index in 0 ..< mapHeight {
                            rangeStart = tileIDs.count - ((index + 1) * mapWidth )
                            
                            let row : [Int] = Array(tileIDs[rangeStart...rangeStart+rangeLength])
                            rowArray.append(row)
                        }
                        
                        //creating a 2d array to make it easy to locate sprites by index
                        var sprites = Array(count: mapWidth, repeatedValue:Array(count: mapHeight, repeatedValue: SKASprite()))
                        
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
                                    
                                    //creating collision body if special SKACollision type is set
                                    if  let properties = sprite.properties{
                                        if let collisionType = properties["SKACollisionType"] as? String{
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
                                    
                                    sprites[columnIndex][rowIndex] = sprite
                                }
                            }
                        }
                        
                        spriteLayer.sprites = sprites
                        spriteLayer.zPosition = CGFloat(layerNumber)
                        addChild(spriteLayer)
                        spriteLayers.append(spriteLayer)
                        
                        layerNumber += 1
                    }
                    
                    //determining if we are working with an object layer
                    if let objectsArray = layerDictionary["objects"] as? [AnyObject]{
                        
                        //creating an object layer to hold object layer info
                        let objectLayer = SKAObjectLayer(properties: layerDictionary)
                        var collisionSprites = [SKNode]()
                        var objects = [SKAObject]()
                        
                        for objectDictionary in objectsArray{
                            
                            if let properties = objectDictionary as? [String : AnyObject]{
                                
                                let object = SKAObject(properties: properties)
                                
                                //getting origin in the correct position based on draw order
                                if(objectLayer.drawOrder == "topdown")
                                {
                                    object.y = (mapHeight * tileHeight) - object.y - object.height;
                                }
                                
                                //creating collision body if special SKACollision type is set
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
                                        }else if collisionType == "SKACollisionTypeShape"{
                                            
                                            if object.polygon != nil{
                                                
                                                let points = object.polygon!
                                                let myPath = UIBezierPath();
                                                myPath.moveToPoint(CGPoint(x: 0,y: 0))
                                                
                                                for set in points{
                                                    let x = set["x"]!
                                                    var y = set["y"]!
                                                    
                                                    //getting origin in the correct position based on draw order
                                                    if(objectLayer.drawOrder == "topdown")
                                                    {
                                                        y = -y
                                                    }
                                                    
                                                    if x != 0 && y != 0{
                                                        myPath.addLineToPoint(CGPoint(x: x,y: y))
                                                    }
                                                }
                                                
                                                let shapeNode = SKShapeNode(path: myPath.CGPath)
                                                shapeNode.zPosition = CGFloat(layerNumber)
                                                let centerX = CGFloat(object.x+object.width/2)
                                                let centerY = CGFloat(object.y+object.height/2)
                                                shapeNode.position = CGPointMake(centerX, centerY)
                                                shapeNode.physicsBody = SKPhysicsBody(polygonFromPath: shapeNode.path!)
                                                shapeNode.physicsBody?.dynamic = false
                                                shapeNode.physicsBody!.categoryBitMask = SKAColliderType.Floor.rawValue;
                                                shapeNode.physicsBody!.contactTestBitMask = SKAColliderType.Player.rawValue;
                                                addChild(shapeNode)
                                                collisionSprites.append(shapeNode)
                                                
                                            }
                                        }

                                    }
                                }
                                
                                objects.append(object)
                            }
                        }
                        
                        objectLayer.collisionSprites = collisionSprites;
                        
                        objectLayer.objects = objects;
                        objectLayers.append(objectLayer)
                        layerNumber += 1;
                    }
                }
            }
        }
    }
    
    
    /**
     Lame required function for subclassing
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}