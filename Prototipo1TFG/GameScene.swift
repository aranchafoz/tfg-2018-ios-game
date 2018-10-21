//
//  GameScene.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 18/4/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import SpriteKit

let gatoWalkHorizontalReduction: CGFloat = 125
let pandaWalkHorizontalReduction: CGFloat = 107
let gatoDefendHorizontalReduction: CGFloat = 55
let pandaDefendHorizontalReduction: CGFloat = 54

class GameScene: SKScene {
    
    let gato: Character
    let panda: NPC
    
    var lastUpdatedTime : TimeInterval = 0 // Última vez que hemos actualizado la pantalla en el método update
    var dt : TimeInterval = 0 // Delta time desde la última actualización
    
    var lastTouchLocation = CGPoint.zero
    
    let playableArea: CGRect
    
    let catSound = SKAction.playSoundFileNamed("hitCat", waitForCompletion: false)
    let bearSound = SKAction.playSoundFileNamed("hitBear", waitForCompletion: false)
    
    var isInvincibleFriend: Bool
    
    var isGameOver: Bool
    var updates: Int
    
    let catLive: SKLabelNode
    let pandaLive: SKLabelNode
    
    override init(size: CGSize) {
        // Define playable area
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2
        playableArea = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        // Init sprites
        gato = Character(name: "gato", lifePoints: 200, spritePixelsPerSecond: 300)
        panda = NPC(name: "panda", lifePoints: 200, spritePixelsPerSecond: 200, opponent: gato)
        

        isInvincibleFriend = false
        
        isGameOver = false
        updates = 0
        
        // HUD
        catLive = SKLabelNode(fontNamed: "Arial")
        pandaLive = SKLabelNode(fontNamed: "Arial")
        
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
        let gatoSpriteSize = CGSize(width: spriteHeight*1.547, height: spriteHeight)
        let pandaSpriteSize = CGSize(width: spriteHeight*1.444, height: spriteHeight)
        
        gato.sprite.name = "friend"
        gato.sprite.zPosition = 3
        gato.sprite.position = CGPoint(x: 1.5*(size.width/6), y: size.height/4)
        gato.sprite.scale(to: gatoSpriteSize)
        addChild(gato.sprite)
        
        panda.sprite.name = "enemy1"
        panda.sprite.zPosition = 3
        panda.sprite.position = CGPoint(x: 4.5*(size.width/6), y: size.height/4)
        panda.sprite.scale(to: pandaSpriteSize)
        addChild(panda.sprite)
        
        playBackgroundMusic(filename: "tension_electrica_relax.mp3")
        
        // HUD
        catLive.text = "\(gato.name): \(gato.life)"
        catLive.position = CGPoint(x: size.width * 0.25, y: size.height * 0.8)
        catLive.fontSize = 80
        catLive.fontColor = UIColor.red
        catLive.verticalAlignmentMode = .center
        catLive.horizontalAlignmentMode = .center
        catLive.zPosition = 10
        addChild(catLive)
        
        pandaLive.text = "\(panda.name): \(panda.life)"
        pandaLive.position = CGPoint(x: size.width * 0.75, y: size.height * 0.8)
        pandaLive.fontSize = 80
        pandaLive.fontColor = UIColor.red
        pandaLive.verticalAlignmentMode = .center
        pandaLive.horizontalAlignmentMode = .center
        pandaLive.zPosition = 10
        addChild(pandaLive)
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
        
        panda.update(deltaTime: dt, opponent: gato)
        
        panda.updateDirection(opponentPosition: gato.sprite.position)
        gato.updateDirection(opponentPosition: panda.sprite.position)
        
        
        // COMPROBAR FIN
        
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
        
        
        updateHUD()
    }
    
    func sceneTouched(touchedLocation: CGPoint) {
        lastTouchLocation = touchedLocation
        gato.moveTo(location: touchedLocation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchPosition = touch.location(in: self)
        
        if (touchPosition.x) > self.size.width/2 {
            
            gato.attackWith(attackType: AttackType.NORMAL, onCompletion: nil) // FIXME: set onCompletion optional
            
            checkCollisionsWithEnemy(attacker: self.gato, kicked: self.panda)
            
        } else {
            
            gato.defend(onCompletion: nil)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gato.isDefending {
            gato.stopAnimation(action: "defend")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        sceneTouched(touchedLocation: location)
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
    
    func characterHit(attacker: Character, kicked: Character) {
        //print("El gato y el enemigo han colisionado")
        
        if attacker.isAttacking {
            attacker.attackHaveHitEnemy = true
            kicked.isAttackedBy(characther: attacker)
            run(catSound, withKey: "hitFriend") //run(bearSound, withKey: "hitEnemy")
            kicked.makeInvincible()
            
            if kicked.isDefeated() {
                kicked.sprite.removeFromParent()
            }
        }
        
        print("Attacker: \(attacker.life)")
        print("Kicked: \(kicked.life)")
    }
    
    func checkCollisionsWithEnemy(attacker: Character, kicked: Character) {
        
        //enumerateChildNodes(withName: "enemy*") { (node, _ in) in
            //let enemy = node as! SKSpriteNode
            
        if !kicked.isInvincible {
        
            let attackerFrame = attacker.sprite.frame
            let kickedFrame = kicked.sprite.frame
            
            var startX: CGFloat = 0.0
        
            if attacker.direction == Direction.RIGHT {
                startX = attackerFrame.midX
            } else if attacker.direction == Direction.LEFT {
                startX = attackerFrame.minX
            }
            
            let attackRect = CGRect(x: startX, y: attackerFrame.minY, width: attackerFrame.width/2, height: attackerFrame.height)
            
            var horizontalReduction: CGFloat = 0
            
            if kicked.isDefending {
                horizontalReduction = (kicked.name == "panda") ? pandaDefendHorizontalReduction : gatoDefendHorizontalReduction
            } else if !kicked.isAttacking {
                horizontalReduction = (kicked.name == "panda") ? pandaWalkHorizontalReduction : gatoWalkHorizontalReduction
            }
            
            let kickedRect = CGRect(x: kickedFrame.minX + horizontalReduction, y: kickedFrame.minY, width: kickedFrame.width - (horizontalReduction*2), height: kickedFrame.height)
            
            // Si colisiona con el ataque del gato
            if kickedRect.intersects(attackRect) {
                self.characterHit(attacker: attacker, kicked: kicked)
            }
        }

    }
    
    func updateHUD() {
        catLive.text = "\(gato.name): \(gato.life)"
        pandaLive.text = "\(panda.name): \(panda.life)"
    }
    
    override func didEvaluateActions() {
        print(panda.isAttacking)
        if panda.isAttacking && !panda.attackHaveHitEnemy {
            checkCollisionsWithEnemy(attacker: panda, kicked: gato)
        }
    }
}
