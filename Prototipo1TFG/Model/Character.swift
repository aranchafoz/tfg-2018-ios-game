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
    let walkAnimation: SKAction
    let normalAttackAnimation: SKAction
    //let especialAttackAnimation: SKAction
    //let defenseAnimation: SKAction
    
    let name: String
    
    var life: CGFloat
    
    let normalAttack: CGFloat = 20.0
    let especialAttack: CGFloat = 50.0
    
    var especialCharges: Int
    
    var isAttacking: Bool
    var isDefending: Bool
    
    init(name: String, lifePoints: CGFloat) {
        sprite = SKSpriteNode(imageNamed: "\(name)2")
        
        self.name = name
        
        life = lifePoints
        
        especialCharges = 0
        
        isAttacking = false
        isDefending = false
        
        // Init animations
        var walkTextures: [SKTexture] = []
        for i in 1...3 {
            walkTextures.append(SKTexture(imageNamed: "\(name)\(i)"))
        }
        walkTextures.append(walkTextures[1])
        walkAnimation = SKAction.repeatForever(SKAction.animate(with: walkTextures, timePerFrame: 0.15))
        
        var normalAttackTextures: [SKTexture] = []
        for i in 1...4 {
            normalAttackTextures.append(SKTexture(imageNamed: "\(name)_normalAttack\(i)"))
        }
        normalAttackAnimation = SKAction.repeatForever(SKAction.animate(with: normalAttackTextures, timePerFrame: 0.15))
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attackTo(enemy: Character, attackType: AttackType) {
        if attackType == AttackType.NORMAL {
            isAttacking = true
            
            sprite.run(SKAction.sequence([normalAttackAnimation, SKAction.wait(forDuration: 1)]), completion: {
                self.isAttacking = false // end attack animation
            })
            
            enemy.life -= normalAttack
            especialCharges += 1
        } else if attackType == AttackType.ESPECIAL && especialCharges >= 3 {
            isAttacking = true
            
            // TODO: execute especial animation
            
            // isAttacking = false // end attack animation
            
            enemy.life -= especialAttack
            especialCharges = 0
        }
    }
    
    func defend() {
        isDefending = true
    }
    
    func isDefeated() -> Bool {
        return life <= 0.0
    }
    
}
