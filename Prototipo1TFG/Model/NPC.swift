//
//  CpuComponent.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 6/7/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import GameplayKit

class NPC: Character {
    
    var stateMachine: GKStateMachine
    
    var opponent: Character
    
    var dt : TimeInterval = 0 // Delta time desde la última actualización
    
    init(name: String, lifePoints: CGFloat, spritePixelsPerSecond: CGFloat, opponent: Character) {
        
        stateMachine = GKStateMachine(states: [])
        
        self.opponent = opponent
        
        super.init(name: name, lifePoints: lifePoints, spritePixelsPerSecond: spritePixelsPerSecond)
        
        
        let idle = NPCIdleState(entity: self)
        let attack = NPCAttackState(entity: self)
        let defend = NPCDefendState(entity: self)
        let moveTo = NPCMoveToState(entity: self)
        let defeated = NPCDefendState(entity: self)
        
        stateMachine = GKStateMachine(states: [idle, attack, defend, moveTo, defeated])
        
        stateMachine.enter(NPCIdleState.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime dt: TimeInterval, opponent: Character) {
        self.opponent = opponent
        
        self.dt = dt
        
        stateMachine.update(deltaTime: dt)
    }
    
    func decideState() {
        
        // Enemy isReachable
        if opponent.sprite.frame.intersects(self.sprite.frame) {
            
            // Defend
            if opponent.isAttacking {
                stateMachine.enter(NPCDefendState.self)
            }
            // Idle
            else if opponent.isDefending {
                stateMachine.enter(NPCIdleState.self)
            }
            // Attack
            else {
                stateMachine.enter(NPCAttackState.self)
            }
        }
        // Move To
        else {
            stateMachine.enter(NPCMoveToState.self)
        }
    }
}
