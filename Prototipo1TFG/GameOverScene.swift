//
//  GameOverScene.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 30/6/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let hasWon:Bool
    
    init(size: CGSize, hasWon: Bool) {
        self.hasWon = hasWon
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) no ha sido implementado. ERROR!!")
    }
    
    override func didMove(to view: SKView) {
        
        let background: SKSpriteNode
        
        if(hasWon) {
            background = SKSpriteNode(imageNamed: "youWin")
            run(SKAction.sequence([SKAction.wait(forDuration: 0.25), SKAction.playSoundFileNamed("win", waitForCompletion: true)]))
        } else {
            background = SKSpriteNode(imageNamed: "youLose")
            run(SKAction.sequence([SKAction.wait(forDuration: 0.25), SKAction.playSoundFileNamed("lose", waitForCompletion: true)]))
        }
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.scale(to: CGSize(width: size.width, height: size.height))
        addChild(background)
    }
}
