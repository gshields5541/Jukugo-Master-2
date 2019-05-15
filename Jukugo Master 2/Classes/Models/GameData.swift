//
//  GameData.swift
//  Jukugo Master
//
//  Created by Gerald F. Shields Jr. on 4/13/19.
//  Copyright © 2019 Gerald Shields. All rights reserved.
//

import Foundation

class GameData {
    //store the user's game achivement
    var points: Int = 0 {
        didSet {
            //custom setter - keep the score positive
            points = max(points, 0)
        }
    }
}
