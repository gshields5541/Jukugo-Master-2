//
//  Config.swift
//  Jukugo Master
//
//  Created by Gerald Shields on 1/08/2014.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

import Foundation
import UIKit

//UI Constants
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let TileMargin: CGFloat = 20.0

let FontHUD = UIFont(name: "comic andy", size: 62.0)
let FontHUDBig = UIFont(name: "comic andy", size: 120.0)

//Sound Effects
let SoundDing = "ding.mp3"
let SoundWrong = "wrong.m4a"
let SoundWin = "win.mp3"
let AudioEffectFiles = [SoundDing, SoundWrong, SoundWin]



//Random number generator
func randomNumber(min:UInt32, max:UInt32) -> Int {
    let result = (arc4random() % (max - min + 1)) + min
  return Int(result)
}

