//
//  NPCMoveToState.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 24/7/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import GameplayKit

class NPCMoveToState: NPCState {
    
    var opponentLocation: CGPoint = CGPoint.zero
    
    override func update(deltaTime seconds: TimeInterval) {
        opponentLocation = entity.opponent.sprite.position //- CGPoint(x: entity.opponent.sprite.frame.width/2, y: 0)
        
        entity.moveTo(location: opponentLocation)
        
        // TODO: Add if clause about collitions with other characters
        
        //if(entity.sprite.position - opponentLocation).length() < entity.velocity.length() * CGFloat(seconds) {
        if entity.arriveTo(destiny: opponentLocation, deltaTime: seconds)
            || entity.collideWith(obstacles: [entity.opponent.sprite], deltaTime: seconds) {
            entity.velocity = CGPoint.zero
            entity.decideState()
        } else {
            entity.movePositionAt(deltaTime: seconds)
        }
    
    }
    
    override func didEnter(from previousState: GKState?) {
 
        stopAnimations(from: previousState)
        
        
        entity.moveTo(location: opponentLocation)
    }
}
