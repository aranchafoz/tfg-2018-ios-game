//
//  NPCDefeatedState.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 24/7/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import GameplayKit

class NPCDefeatedState: NPCState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
}
