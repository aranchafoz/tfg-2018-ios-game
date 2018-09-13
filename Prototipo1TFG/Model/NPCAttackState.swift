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
        
        stopAnimations(from: previousState)
        
        // TODO: finish
        entity.attackWith(attackType: AttackType.NORMAL, onCompletion: entity.decideState)
        
    }
}
