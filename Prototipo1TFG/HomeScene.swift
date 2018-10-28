//
//  HomeScene.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 28/10/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import Foundation
import SpriteKit

class HomeScene: SKScene, ButtonDelegate {
    
    var playButton: Button
    
    override init(size: CGSize) {
        
        let buttonTexture = SKTexture(imageNamed: "buttonPlay")
        let buttonTextureHover = SKTexture(imageNamed: "buttonPlay")
        self.playButton = Button(texture: buttonTexture, textureHover: buttonTextureHover, color: .black, size: CGSize(width: size.width/6, height: size.height/12))
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "homeExample")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.scale(to: CGSize(width: size.width, height: size.height))
        background.zPosition = 0
        addChild(background)
        
        
        playButton.name = "button-play"
        playButton.position = CGPoint(x: size.width/2, y: size.height/3)
        playButton.delegate = self
        playButton.zPosition = 4
        addChild(playButton)
    }
    
    func buttonClicked(sender: Button) {
        print("button named \(sender.name!)")
        if sender.name == "button-play" {
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            let transition = SKTransition.doorsOpenVertical(withDuration: 1.0)
            view?.presentScene(gameScene, transition: transition)
        }
    }
    
}
