//
//  Button.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 27/10/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import Foundation
import SpriteKit

protocol ButtonDelegate: class {
    func buttonClicked(sender: Button)
}

class Button: SKSpriteNode {
    
    //weak so that you don't create a strong circular reference with the parent
    weak var delegate: ButtonDelegate!
    
    let textureNormal: SKTexture
    let textureHover: SKTexture
    
    init(texture: SKTexture?, textureHover: SKTexture?, color: SKColor, size: CGSize) {
        
        self.textureNormal = texture!
        self.textureHover = textureHover!
        
        super.init(texture: texture, color: color, size: size)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.texture = self.textureHover
        setScale(0.9)
        self.delegate.buttonClicked(sender: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.texture = self.textureNormal
        setScale(1.0)
    }
}
