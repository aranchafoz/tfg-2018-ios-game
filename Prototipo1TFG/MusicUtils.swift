//
//  MusicUtils.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 30/6/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import Foundation
import AVFoundation

var backgroundAudioPlayer : AVAudioPlayer!

func playBackgroundMusic(filename: String) {
    let urlSound = Bundle.main.url(forResource: filename, withExtension: nil)
    if urlSound == nil {
        return
    }
    
    do {
        backgroundAudioPlayer = try AVAudioPlayer(contentsOf: urlSound!)
        if backgroundAudioPlayer == nil {
            return
        }
        
        backgroundAudioPlayer.numberOfLoops = -1
        backgroundAudioPlayer.prepareToPlay()
        backgroundAudioPlayer.play()
    } catch {
        print("ERROR!")
    }
}
