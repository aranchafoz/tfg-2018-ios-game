//
//  GameScene.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 18/4/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let gato: Character
    let panda: Character
    
    var lastUpdatedTime : TimeInterval = 0 // Última vez que hemos actualizado la pantalla en el método update
    var dt : TimeInterval = 0 // Delta time desde la última actualización
    
    var lastTouchLocation = CGPoint.zero
    
    let playableArea: CGRect
    
    let catSound = SKAction.playSoundFileNamed("hitCat", waitForCompletion: false)
    let bearSound = SKAction.playSoundFileNamed("hitBear", waitForCompletion: false)
    
    var isInvincibleFriend: Bool
    
    var isGameOver: Bool
    var updates: Int
    
    override init(size: CGSize) {
        // Define playable area
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2
        playableArea = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        // Init sprites
        gato = Character(name: "gato", lifePoints: 200, spritePixelsPerSecond: 300)
        panda = Character(name: "panda", lifePoints: 200, spritePixelsPerSecond: 250)
        

        isInvincibleFriend = false
        
        isGameOver = false
        updates = 0
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("El método init coder no ha sido implementado")
    }
    
    override func didMove(to view: SKView) {
        // Background
        let background = SKSpriteNode(imageNamed: "back1")
        background.zPosition = -1
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.scale(to: CGSize(width: playableArea.width, height: playableArea.height))
        addChild(background)
        
        
        let spriteHeight = playableArea.height * 0.3
        let spriteSize = CGSize(width: spriteHeight*0.83, height: spriteHeight)
        
        gato.sprite.name = "friend"
        gato.sprite.zPosition = 3
        gato.sprite.position = CGPoint(x: 1.5*(size.width/6), y: size.height/4)
        gato.sprite.scale(to: spriteSize)
        addChild(gato.sprite)
        
        panda.sprite.name = "enemy1"
        panda.sprite.zPosition = 5
        panda.sprite.position = CGPoint(x: 4.5*(size.width/6), y: size.height/4)
        panda.sprite.scale(to: spriteSize)
        addChild(panda.sprite)
        
        playBackgroundMusic(filename: "tension_electrica_relax.mp3")
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdatedTime > 0 {
            dt = currentTime - lastUpdatedTime
        } else {
            dt = 0
        }
        
        lastUpdatedTime = currentTime
        
        checkBounds()
        
        if(gato.sprite.position - lastTouchLocation).length() < gato.velocity.length() * CGFloat(dt) {
            gato.velocity = CGPoint.zero
            gato.stopAnimation(action: "walk")
        } else {
            gato.movePositionAt(deltaTime: dt)
        }
        
        if gato.isDefeated() && !isGameOver {
            isGameOver = true
            print("Tu personaje se ha quedado sin vida. You lose")
            
            backgroundAudioPlayer.stop()
            
            // Scene change
            let gameOverScene = GameOverScene(size: size, hasWon: false)
            gameOverScene.scaleMode = scaleMode
            let transition = SKTransition.flipVertical(withDuration: 1.0)
            view?.presentScene(gameOverScene, transition: transition)
        }
        
        
        if panda.isDefeated() && !isGameOver {
            isGameOver = true
            print("You win")
            
            backgroundAudioPlayer.stop()
            
            // Scene change
            let gameOverScene = GameOverScene(size: size, hasWon: true)
            gameOverScene.scaleMode = scaleMode
            let transition = SKTransition.flipVertical(withDuration: 1.0)
            view?.presentScene(gameOverScene, transition: transition)
        } else {
            updates += 1
        }
    }
    
    func sceneTouched(touchedLocation: CGPoint) {
        lastTouchLocation = touchedLocation
        gato.moveTo(location: touchedLocation)
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
    
    @objc func doubleTapped() {
        print("Double Tap")
        gato.attackWith(attackType: AttackType.NORMAL)
        
        checkCollisions() // FIXME: Refactor to a especific function
    }
    
    func checkBounds() {
        let bottomLetf = CGPoint(x: 0, y: playableArea.minY)
        let upperRigth = CGPoint(x: playableArea.width, y: playableArea.maxY)
        
        if gato.sprite.position.x <= bottomLetf.x {
            gato.sprite.position.x = bottomLetf.x
            gato.velocity.x = -gato.velocity.x
        }
        
        if gato.sprite.position.y <= bottomLetf.y {
            gato.sprite.position.y = bottomLetf.y
            gato.velocity.y = -gato.velocity.y
        }
        
        if gato.sprite.position.x >= upperRigth.x {
            gato.sprite.position.x = upperRigth.x
            gato.velocity.x = -gato.velocity.x
        }
        
        if gato.sprite.position.y >= upperRigth.y {
            gato.sprite.position.y = upperRigth.y
            gato.velocity.y = -gato.velocity.y
        }
    }
    
    func charactersHit(friend: Character, enemy: Character) {
        print("El gato y el enemigo han colisionado")
        
        if gato.isAttacking {
            panda.isAttackedBy(characther: gato)
            run(catSound, withKey: "hitFriend")
            panda.makeInvincible()
            
            if panda.isDefeated() {
                panda.sprite.removeFromParent()
            }
        }
        
        if panda.isAttacking {
//            panda.attackTo(enemy: gato, attackType: AttackType.NORMAL)
//            run(bearSound, withKey: "hitEnemy")
//            gato.makeInvincible()
//
//            if gato.isDefeated() {
//                gato.sprite.removeFromParent()
//            }
        }
        
        print("Gato: \(gato.life)")
        print("Panda: \(panda.life)")
    }
    
    func checkCollisions() {
        
        // Comprobar colisión con enemigo
        enumerateChildNodes(withName: "enemy*") { (node, _ in) in
            let enemy = node as! SKSpriteNode
            
            if !self.gato.isInvincible {
            
                // TODO: Si el gato ataca con dirección izquierda
                // Si el gato ataca con dirección derecha
                let gatoFrame = self.gato.sprite.frame
                let gatoAttackRect = CGRect(x: gatoFrame.midX, y: gatoFrame.minY, width: gatoFrame.width/2, height: gatoFrame.height)
            
                // Si colisiona con el ataque del gato
                if enemy.frame.intersects(gatoAttackRect) {
                    // panda
                    if enemy.name == "enemy1" {
                        self.charactersHit(friend: self.gato, enemy: self.panda)
                    }
                }
            }
        }

    }
    
    override func didEvaluateActions() {
        //checkCollisions()
    }
}
