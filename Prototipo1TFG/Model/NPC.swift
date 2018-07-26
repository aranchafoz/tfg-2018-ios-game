//
//  CpuComponent.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 6/7/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import GameplayKit

class NPC: Character {
    
    let stateMachine: GKStateMachine
    
    let actionPlaying: String
    
    override init(name: String, lifePoints: CGFloat, spritePixelsPerSecond: CGFloat) {
        
        stateMachine = GKStateMachine(states: [])
        
        actionPlaying = ""
        
        super.init(name: name, lifePoints: lifePoints, spritePixelsPerSecond: spritePixelsPerSecond)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func decideState() {
        // TODO: Implement
    }
}
