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
        
        print("Defend State did enter")
        
        stopAnimations(from: previousState)
        
        // TODO: finish
        entity.defend(onCompletion: entity.decideState)
        
    }
}
