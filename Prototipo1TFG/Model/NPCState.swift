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
}
