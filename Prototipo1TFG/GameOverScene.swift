//
//  GameOverScene.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 30/6/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene, ButtonDelegate {
    
    private var button: Button
    
    let hasWon:Bool
    
    init(size: CGSize, hasWon: Bool) {
        self.hasWon = hasWon
        
        
        let buttonTexture = SKTexture(imageNamed: "buttonTryAgain")
        let buttonTextureHover = SKTexture(imageNamed: "buttonTryAgainHover")
        self.button = Button(texture: buttonTexture, textureHover: buttonTextureHover, color: .black, size: CGSize(width: size.width/6, height: size.height/12))
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) no ha sido implementado. ERROR!!")
    }
    
    override func didMove(to view: SKView) {
        
        setBackground()
        
        button.name = "button-tryagain"
        button.position = CGPoint(x: size.width/2, y: size.height/3)
        button.delegate = self
        button.zPosition = 4
        addChild(button)
    }
    
    
    func buttonClicked(sender: Button) {
        print("button named \(sender.name!)")
        if sender.name == "button-tryagain" {
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            let transition = SKTransition.doorsOpenVertical(withDuration: 1.0)
            view?.presentScene(gameScene, transition: transition)
        }
    }
    
    func setBackground() {
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
        background.zPosition = 0
        addChild(background)
    }
}
