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
    
    let catName: SKLabelNode
    let pandaName: SKLabelNode
    
    let lifeBarSize: CGSize
    let catLifeBar: SKSpriteNode
    let catLifeBarBack: SKSpriteNode
    let pandaLifeBar: SKSpriteNode
    let pandaLifeBarBack: SKSpriteNode
    
    override init(size: CGSize) {
        // Define playable area
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2
        playableArea = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        // Init sprites
        gato = Character(name: "gato", lifePoints: 200, spritePixelsPerSecond: 500)
        panda = NPC(name: "panda", lifePoints: 200, spritePixelsPerSecond: 150, opponent: gato)
        

        isInvincibleFriend = false
        
        isGameOver = false
        updates = 0
        
        // HUD
        catName = SKLabelNode(fontNamed: "AvenirNext-Bold")
        pandaName = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        lifeBarSize = CGSize(width: size.width * 0.4, height: 65)
        
        catLifeBar = SKSpriteNode(color: SKColor.green, size: lifeBarSize)
        catLifeBarBack = SKSpriteNode(color: SKColor.black, size: CGSize(width: lifeBarSize.width + 10, height: lifeBarSize.height + 10))
        
        pandaLifeBar = SKSpriteNode(color: SKColor.green, size: lifeBarSize)
        pandaLifeBarBack = SKSpriteNode(color: SKColor.black, size: CGSize(width: lifeBarSize.width + 10, height: lifeBarSize.height + 10))
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("El método init coder no ha sido implementado")
    }
    
    override func didMove(to view: SKView) {
        // Background
        let background = SKSpriteNode(imageNamed: "escenario1")
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
        catName.text = "\(gato.name)"
        catName.position = CGPoint(x: size.width * 0.055, y: size.height * 0.8 + 50)
        catName.fontSize = 50
        catName.fontColor = UIColor.black
        catName.verticalAlignmentMode = .center
        catName.horizontalAlignmentMode = .left
        catName.zPosition = 10
        addChild(catName)
        
        pandaName.text = "\(panda.name)"
        pandaName.position = CGPoint(x: size.width * 0.555, y: size.height * 0.8 + 50)
        pandaName.fontSize = 50
        pandaName.fontColor = UIColor.black
        pandaName.verticalAlignmentMode = .center
        pandaName.horizontalAlignmentMode = .left
        pandaName.zPosition = 10
        addChild(pandaName)
        
        catLifeBar.position = CGPoint(x: size.width * 0.05, y: size.height * 0.76)
        catLifeBar.zPosition = 10
        catLifeBar.anchorPoint = CGPoint(x: -0.007, y: -0.075)
        addChild(catLifeBar)
        
        catLifeBarBack.position = CGPoint(x: size.width * 0.05, y: size.height * 0.76)
        catLifeBarBack.zPosition = 9
        catLifeBarBack.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(catLifeBarBack)
        
        pandaLifeBar.position = CGPoint(x: size.width * 0.55, y: size.height * 0.76)
        pandaLifeBar.zPosition = 10
        pandaLifeBar.anchorPoint = CGPoint(x: -0.007, y: -0.075)
        addChild(pandaLifeBar)
        
        pandaLifeBarBack.position = CGPoint(x: size.width * 0.55, y: size.height * 0.76)
        pandaLifeBarBack.zPosition = 9
        pandaLifeBarBack.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(pandaLifeBarBack)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdatedTime > 0 {
            dt = currentTime - lastUpdatedTime
        } else {
            dt = 0
        }
        lastUpdatedTime = currentTime
        
        checkBounds()
        
        panda.updateDirection(opponentPosition: gato.sprite.position)
        gato.updateDirection(opponentPosition: panda.sprite.position)
        
        if gato.arriveTo(destiny: lastTouchLocation, deltaTime: dt)
            || gato.collideWith(obstacles: [panda.sprite], deltaTime: dt) {
            gato.velocity = CGPoint.zero
            gato.stopAnimation(action: "walk")
        } else {
            gato.movePositionAt(deltaTime: dt)
        }
        
        panda.update(deltaTime: dt, opponent: gato)
        
        updateHUD()
    
        checkGameEnd()
    }
    
    func sceneTouched(touchedLocation: CGPoint) {
        lastTouchLocation = touchedLocation
        gato.moveTo(location: touchedLocation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchPosition = touch.location(in: self)
        
        if (touchPosition.x) > self.size.width/2 {
            
            gato.attackWith(attackType: AttackType.NORMAL, onCompletion: nil)
            
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
        let catLifePercentage = gato.life / gato.maxLife
        catLifeBar.size = CGSize(width: lifeBarSize.width * catLifePercentage, height: lifeBarSize.height)
        
        let pandaLifePercentage = panda.life / panda.maxLife
        pandaLifeBar.size = CGSize(width: lifeBarSize.width * pandaLifePercentage, height: lifeBarSize.height)
    }
    
    func checkGameEnd() {
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
    
    override func didEvaluateActions() {
        
        // Enemy attack
        if panda.isAttacking && !panda.attackHaveHitEnemy {
            checkCollisionsWithEnemy(attacker: panda, kicked: gato)
        }
        
    }
}
