//
//  NPCState.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 26/7/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import GameplayKit

class NPCState: GKState {
    let entity: NPC
    
    init(entity: NPC) {
        self.entity = entity
    }
    
    func stopAnimations(from previousState: GKState?) {
        switch previousState {
        case is NPCIdleState:
            break
        case is NPCDefendState:
            entity.stopAnimation(action: "defend")
        case is NPCMoveToState:
            entity.stopAnimation(action: "walk")
        case is NPCAttackState:
            entity.stopAnimation(action: "normalAttack")
        default:
            break
        }
    }
}
