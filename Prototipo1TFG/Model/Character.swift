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

class Character: GKEntity {
    
    let sprite: SKSpriteNode
    var animations: [String:SKAction] = [:]
    
    let name: String
    
    var life: CGFloat
    
    let spritePixelsPerSecond: CGFloat
    var velocity = CGPoint.zero
    
    let normalAttack: CGFloat = 20.0
    let especialAttack: CGFloat = 50.0
    
    var especialCharges: Int
    
    var isAttacking: Bool
    var isDefending: Bool
    
    var isInvincible: Bool
    
    
    init(name: String, lifePoints: CGFloat, spritePixelsPerSecond: CGFloat) {
        sprite = SKSpriteNode(imageNamed: "\(name)_walk2")
        
        self.name = name
        
        life = lifePoints
        
        self.spritePixelsPerSecond = spritePixelsPerSecond
        
        especialCharges = 0
        
        isAttacking = false
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
        
        animations["base"] = baseAnimation
        animations["walk"] = walkAnimation
        animations["normalAttack"] = normalAttackAnimation
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attackWith(attackType: AttackType) {
        print("El personaje ataca con: \(attackType)")
        
        if attackType == AttackType.NORMAL {
            isAttacking = true
            let spriteHeight = sprite.size.height
            let scale = SKAction.scale(to: CGSize(width: spriteHeight * 1.17, height: spriteHeight), duration: 0)
            let attackAction = animations["normalAttack"]
            let group1 = SKAction.group([scale, attackAction!])
            
            
            let rescale = SKAction.scale(to: CGSize(width: spriteHeight * 0.83, height: spriteHeight), duration: 0)
            let baseAction = animations["base"]
            let group2 = SKAction.group([rescale, baseAction!])
            
            let endAttack = SKAction.run {
                print("Gato is attacking = false")
                self.isAttacking = false
            }
            sprite.run(SKAction.sequence([group1, group2, SKAction.wait(forDuration: 2), endAttack]))
            especialCharges += 1
        } else if attackType == AttackType.ESPECIAL && especialCharges >= 3 {
            
            // TODO: execute especial animation
            
            especialCharges = 0
        }
    }
    
    func isAttackedBy(characther: Character) {
        self.life -= characther.normalAttack
    }
    
    func defend() {
        isDefending = true
        // TODO: execute defend animation
    }
    
    func isDefeated() -> Bool {
        // TODO: if true -> execute defeated animation
        return life <= 0.0
    }
    
    func moveTo(location: CGPoint) {
        animate(action: "walk")
        
        let offset = location - sprite.position
        
        let direction = offset.normalize() // Un vector unitario del movimiento
        self.velocity = direction * spritePixelsPerSecond
    }
    
    func movePositionAt(deltaTime: TimeInterval) {
        let amount = velocity * CGFloat(deltaTime)
        sprite.position += amount
    }
    
    func animate(action: String) {
        if sprite.action(forKey: action) == nil {
            sprite.run(animations[action]!, withKey: action)
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
    
}
