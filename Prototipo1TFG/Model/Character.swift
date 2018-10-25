//
//  Character.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 6/7/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum AttackType {
    case NORMAL
    case ESPECIAL
}

enum Direction {
    case RIGHT
    case LEFT
    case NONE
}

class Character: GKEntity {
    
    let sprite: SKSpriteNode
    var animations: [String:SKAction] = [:]
    
    let name: String
    
    var life: CGFloat
    
    let spritePixelsPerSecond: CGFloat
    var velocity = CGPoint.zero
    
    let normalAttack: CGFloat = 20.0
    let especialAttack: CGFloat = 50.0
    
    var direction: Direction
    
    var especialCharges: Int
    
    var isAttacking: Bool
    var attackHaveHitEnemy: Bool
    var isDefending: Bool
    
    var isInvincible: Bool
    
    
    init(name: String, lifePoints: CGFloat, spritePixelsPerSecond: CGFloat) {
        sprite = SKSpriteNode(imageNamed: "\(name)_walk2")
        
        self.name = name
        
        life = lifePoints
        
        self.spritePixelsPerSecond = spritePixelsPerSecond
        
        direction = Direction.NONE
        especialCharges = 0
        
        isAttacking = false
        attackHaveHitEnemy = false
        
        isDefending = false
        
        isInvincible = false
        
        // Init animations
        var walkTextures: [SKTexture] = []
        for i in 1...3 {
            walkTextures.append(SKTexture(imageNamed: "\(name)_walk\(i)"))
        }
        walkTextures.append(walkTextures[1])
        let walkAnimation = SKAction.repeatForever(SKAction.animate(with: walkTextures, timePerFrame: 0.15))
        
        var normalAttackTextures: [SKTexture] = []
        for i in 1...4 {
            let texture = SKTexture(imageNamed: "\(name)_normalAttack\(i)")
            normalAttackTextures.append(texture)
        }
        let normalAttackAnimation = SKAction.animate(with: normalAttackTextures, timePerFrame: 0.15)

        let baseAnimation = SKAction.animate(with: [walkTextures[1]], timePerFrame: 0.15)
        
        let defendTexture = SKTexture(imageNamed: "\(name)_defend")
        let defendAnimation = SKAction.animate(with: [defendTexture], timePerFrame: 0.15)
        
        animations["base"] = baseAnimation
        animations["walk"] = walkAnimation
        animations["normalAttack"] = normalAttackAnimation
        animations["defend"] = defendAnimation
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attackWith(attackType: AttackType, onCompletion: ( () -> Void )? ) {
        
        if attackType == AttackType.NORMAL {
            isAttacking = true
        
            let scale = SKAction.scale(to: CGSize(width: sprite.size.width * CGFloat(getScaleDirection(direction: direction)), height: sprite.size.height), duration: 0)
            let attackAction = animations["normalAttack"]
            let group1 = SKAction.group([scale, attackAction!])
            
            let baseAction = animations["base"]
            
            let endAttack = SKAction.run {
                self.isAttacking = false
                self.attackHaveHitEnemy = false
            }
            if (onCompletion as ( () -> Void )?) != nil {
                sprite.run(SKAction.sequence([group1, baseAction!, SKAction.wait(forDuration: 2), endAttack]), completion: onCompletion!)
            } else {
                sprite.run(SKAction.sequence([group1, baseAction!, SKAction.wait(forDuration: 2), endAttack]))
            }
            especialCharges += 1
        } else if attackType == AttackType.ESPECIAL && especialCharges >= 3 {
            
            // MARK: execute especial animation
            
            especialCharges = 0
        }
    }
    
    func isAttackedBy(characther: Character) {
        if !isDefending {
            self.life -= characther.normalAttack
        }
    }
    
    func defend( onCompletion: ( () -> Void )? ) {
        
        isDefending = true
        
        sprite.run(self.animations["defend"]!)
        
        sprite.run(SKAction.wait(forDuration: 5)) {
            self.isDefending = false
            
            self.sprite.run(self.animations["base"]!)
            
            if (onCompletion as ( () -> Void )?) != nil {
                onCompletion!()
            }
        }
    }
    
    func isDefeated() -> Bool {
        // MARK: if true -> execute defeated animation
        return life <= 0.0
    }
    
    func moveTo(location: CGPoint) {
        let offset = location - sprite.position

        let direction = offset.normalize() // Un vector unitario del movimiento
        self.velocity = direction * spritePixelsPerSecond

        self.direction = (offset.x > 0) ? Direction.RIGHT : Direction.LEFT

        animate(action: "walk")
    }
    
    func movePositionAt(deltaTime: TimeInterval) {
        let amount = velocity * CGFloat(deltaTime)
        sprite.position += amount
    }
    
    func animate(action: String) {
        if sprite.action(forKey: action) == nil {
            let scale = SKAction.scaleX(to: CGFloat(getScaleDirection(direction: direction)), duration: 0)
            let animation = animations[action]
            let group = SKAction.group([scale, animation!])
            sprite.run(group, withKey: action)
        }
    }
    
    func stopAnimation(action: String) {
        if sprite.action(forKey: action) != nil {
            sprite.removeAction(forKey: action)
        }
    }
    
    func makeInvincible() {
        isInvincible = true
        
        let blinkTimes = 4.0
        let blinkDurantion = 1.0
        let blinkAction = SKAction.customAction(withDuration: blinkDurantion) { (node, elapsedTime) in
            let slice = blinkDurantion / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice) // truncatingReminder == operator %
            node.isHidden = remainder > slice / 2
            
        }
        
        let setHidden = SKAction.run {
            self.sprite.isHidden = false
            self.isInvincible = false
        }
        
        sprite.run(SKAction.sequence([blinkAction, setHidden]))
    }
    
    func getScaleDirection(direction: Direction) -> Int {
        switch direction {
        case .RIGHT:
            return 1
        case .LEFT:
            return -1
        default:
            return 0
        }
    }
    
    func updateDirection(opponentPosition: CGPoint) {
        if isDefending || isAttacking {
            self.direction = (opponentPosition.x > sprite.position.x) ? Direction.RIGHT : Direction.LEFT
        }
    }
    
    func arriveTo(destiny: CGPoint, deltaTime: TimeInterval) -> Bool {
        let remainingWalk = (sprite.position - destiny).length()
        let nextMove = velocity.length() * CGFloat(deltaTime)
        return remainingWalk < nextMove
    }
    
    func collideWith(obstacles: [SKNode], deltaTime: TimeInterval) -> Bool {
        let nextAmount = velocity * CGFloat(deltaTime)
        var nextPosition = CGPoint(x: sprite.position.x, y: sprite.position.y)
        nextPosition += nextAmount
        
        let futureSprite = sprite.copy() as! SKNode
        futureSprite.position = nextPosition
        
        let spriteHorizontalReduction = (futureSprite.name == "panda") ? pandaWalkHorizontalReduction : gatoWalkHorizontalReduction
        
        let spriteRect = CGRect(x: futureSprite.frame.minX + spriteHorizontalReduction, y: futureSprite.frame.minY, width: futureSprite.frame.width - (spriteHorizontalReduction*2), height: futureSprite.frame.height)
        
        for node in obstacles {
            
            
            let opponentHorizontalReduction = (futureSprite.name == "panda") ? pandaWalkHorizontalReduction : gatoWalkHorizontalReduction
            
            
            let opponentRect = CGRect(x: node.frame.minX + opponentHorizontalReduction, y: node.frame.minY, width: node.frame.width - (opponentHorizontalReduction*2), height: node.frame.height)
            
            if opponentRect.intersects(spriteRect) {
                return true
            }
        }
        
        return false
        
    }
}
