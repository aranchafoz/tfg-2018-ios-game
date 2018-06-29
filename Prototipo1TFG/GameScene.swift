//
//  GameScene.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 18/4/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let gato = SKSpriteNode(imageNamed: "gato2")
    let panda = SKSpriteNode(imageNamed: "panda1")
    
    let gatoAnimation: SKAction
    
    var lastUpdatedTime : TimeInterval = 0 // Última vez que hemos actualizado la pantalla en el método update
    var dt : TimeInterval = 0 // Delta time desde la última actualización
    
    let spritePixelsPerSecond : CGFloat = 300
    var cuteFriendVelocity = CGPoint.zero
    var lastTouchLocation = CGPoint.zero
    
    let playableArea: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2
        playableArea = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        var gatoTextures: [SKTexture] = []
        for i in 1...3 {
            gatoTextures.append(SKTexture(imageNamed: "gato\(i)"))
        }
        gatoTextures.append(gatoTextures[1])
        
        
        print(gatoTextures)
        
        gatoAnimation = SKAction.repeatForever(SKAction.animate(with: gatoTextures, timePerFrame: 0.15))
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("El método init coder no ha sido implementado")
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "back1")
        background.zPosition = -1
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.scale(to: CGSize(width: playableArea.width, height: playableArea.height))
        addChild(background)
        
        
        let spriteSide = playableArea.height * 0.5
        let spriteSize = CGSize(width: spriteSide*(4/3), height: spriteSide)
        
        gato.zPosition = 3
        gato.position = CGPoint(x: 1.5*(size.width/6), y: size.height/4)
        gato.scale(to: spriteSize)
        
        //gato.run(SKAction.repeatForever(gatoAnimation))
        
        addChild(gato)
        
        panda.zPosition = 5
        panda.position = CGPoint(x: 4.5*(size.width/6), y: size.height/4)
        panda.scale(to: spriteSize)
        addChild(panda)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdatedTime > 0 {
            dt = currentTime - lastUpdatedTime
        } else {
            dt = 0
        }
        
        lastUpdatedTime = currentTime
        
        checkBounds()
        
        if(gato.position - lastTouchLocation).length() < cuteFriendVelocity.length() * CGFloat(dt) {
            cuteFriendVelocity = CGPoint.zero
            stopCuteFriend()
        } else {
            moveSprite(sprite: gato, velocity: cuteFriendVelocity)
        }
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amount = velocity * CGFloat(dt)
        sprite.position += amount
    }
    
    func moveCuteFriendToLocation(location: CGPoint) {
        
        animateCuteFriend()
        
        let offset = location - gato.position
        
        let direction = offset.normalize() // Un vector unitario del movimiento
        cuteFriendVelocity = direction * spritePixelsPerSecond
    }
    
    func sceneTouched(touchedLocation: CGPoint) {
        lastTouchLocation = touchedLocation
        moveCuteFriendToLocation(location: touchedLocation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        sceneTouched(touchedLocation: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        sceneTouched(touchedLocation: location)
    }
    
    func checkBounds() {
        let bottomLetf = CGPoint(x: 0, y: playableArea.minY)
        let upperRigth = CGPoint(x: playableArea.width, y: playableArea.maxY)
        
        if gato.position.x <= bottomLetf.x {
            gato.position.x = bottomLetf.x
            cuteFriendVelocity.x = -cuteFriendVelocity.x
        }
        
        if gato.position.y <= bottomLetf.y {
            gato.position.y = bottomLetf.y
            cuteFriendVelocity.y = -cuteFriendVelocity.y
        }
        
        if gato.position.x >= upperRigth.x {
            gato.position.x = upperRigth.x
            cuteFriendVelocity.x = -cuteFriendVelocity.x
        }
        
        if gato.position.y >= upperRigth.y {
            gato.position.y = upperRigth.y
            cuteFriendVelocity.y = -cuteFriendVelocity.y
        }
    }
    
    func animateCuteFriend() {
        if(gato.action(forKey: "walk") == nil) {
            gato.run(gatoAnimation, withKey: "walk") // Animación para caminar
        }
    }
    
    func stopCuteFriend() {
        if(gato.action(forKey: "walk") != nil) {
            gato.removeAction(forKey: "walk") // Parar de caminar
        }
    }
}
