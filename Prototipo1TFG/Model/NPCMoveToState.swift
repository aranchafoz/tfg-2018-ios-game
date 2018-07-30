//
//  NPCMoveToState.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 24/7/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import GameplayKit

class NPCMoveToState: NPCState {
    
    override func didEnter(from previousState: GKState?) {
        print("Move To State did enter")
        
        stopAnimations(from: previousState)
        
        // TODO: finish
        entity.attackWith(attackType: AttackType.NORMAL, onCompletion: entity.decideState)
        
    }
}
