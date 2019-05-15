//
//  AudioController.swift
//  Jukugo Master
//
//  Created by Gerald F. Shields Jr. on 4/13/19.
//  Copyright © 2019 Gerald Shields. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController {
    private var audio = [String: AVAudioPlayer]()
    
    func preloadAudioEffects(effectFileNames:[String]) {
        for effect in AudioEffectFiles {
            let soundURL = Bundle.main.resourceURL!.appendingPathComponent(effect)
            
            //2 load the file contents
            
            do {
                let player = try AVAudioPlayer(contentsOf: soundURL)
                //3 prepare the play
                player.numberOfLoops = 0
                player.prepareToPlay()
                
                //4 add to the audio dictionary
                audio[effect] = player
                
            } catch { print(error) }
        }
    }
    
    func playEffect(name: String) {
        if let player = audio[name] {
            if player.isPlaying {
                player.currentTime = 0
            } else {
                player.play()
            }
        }
    }
}
