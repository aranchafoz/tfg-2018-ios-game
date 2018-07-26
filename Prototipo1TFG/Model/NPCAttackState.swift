//
//  NPCActiveState.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 17/7/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import GameplayKit

class NPCAttackState: NPCState {
    override func didEnter(from previousState: GKState?) {
        switch previousState {
        case is NPCIdleState:
            break
        case is NPCDefendState:
            entity.stopAnimation(action: "defend")
        case is NPCMoveToState:
            entity.stopAnimation(action: "walk")
        default:
            break
        }
        // TODO: finish
        entity.attackWith(attackType: AttackType.NORMAL, onCompletion: entity.decideState)
        
    }
}
