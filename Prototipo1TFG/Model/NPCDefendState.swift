//
//  NPCDefendState.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 24/7/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import GameplayKit

class NPCDefendState: NPCState {
    
    override func didEnter(from previousState: GKState?) {
        
        stopAnimations(from: previousState)
        
        entity.defend(onCompletion: entity.decideState)
        
        entity.sprite.run(SKAction.wait(forDuration: 5)) {
            self.entity.isDefending = false
            self.entity.decideState()
        }
        
    }
}
