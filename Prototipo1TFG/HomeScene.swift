//
//  HomeScene.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 28/10/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import Foundation
import SpriteKit

class HomeScene: SKScene {
    
    let tapStartLabel: SKSpriteNode
    
    override init(size: CGSize) {
        
        self.tapStartLabel = SKSpriteNode(imageNamed: "tapToStart")
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "homeBackground")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.scale(to: CGSize(width: size.width, height: size.height))
        background.zPosition = 0
        addChild(background)
        
        let title = SKSpriteNode(imageNamed: "gameTitle")
        title.position = CGPoint(x: size.width/2, y: size.height - (size.width/4))
        title.scale(to: CGSize(width: (size.width/5)*2, height: (size.width/5)*2))
        title.zPosition = 4
        addChild(title)
        
        tapStartLabel.position = CGPoint(x: size.width/2, y: size.height/5)
        tapStartLabel.zPosition = 4
        addChild(tapStartLabel)
        
        var blinkAlpha = 1.0
        var alphaAsc = false
        let blinkAction = SKAction.customAction(withDuration: 10.0) { (node, elapsedTime) in
            
            if alphaAsc && blinkAlpha < 1 {
                blinkAlpha += 0.02
            } else {
                alphaAsc = false
                if blinkAlpha > 0.1 {
                    blinkAlpha -= 0.02
                } else {
                    alphaAsc = true
                    blinkAlpha += 0.02
                }
            }
            print("\(blinkAlpha)")
            node.alpha = CGFloat(blinkAlpha)
        }
        tapStartLabel.run(SKAction.repeatForever(blinkAction))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        let transition = SKTransition.doorsOpenVertical(withDuration: 1.0)
        view?.presentScene(gameScene, transition: transition)
    }
    
}
