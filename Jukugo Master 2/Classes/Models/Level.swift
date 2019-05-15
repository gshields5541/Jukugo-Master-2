//
//  Level.swift
//  Jukugo Master
//
//  Created by Gerald F. Shields Jr. on 4/12/19.
//  Copyright © 2019 Gerald Shields. All rights reserved.
//

import Foundation

struct Level {
    let pointsPerTile: Int
    let timeToSolve: Int
    let compounds: [NSArray]
    
    init(levelNumber: Int) {
        //1 find .plist file for this level
        let fileName = "level\(levelNumber).plist"
        let levelPath = "\(Bundle.main.resourcePath!)/\(fileName)"
        
        //2 load .plist file
        let levelDictionary: NSDictionary? = NSDictionary(contentsOfFile: levelPath)
        
        //3 validation
        assert(levelDictionary != nil, "Level configuration file not found")
        
        //4 initialize the object from the dictionary
        self.pointsPerTile = levelDictionary!["pointsPerTile"] as! Int
        self.timeToSolve = levelDictionary!["timeToSolve"] as! Int
        self.compounds = levelDictionary!["compounds"] as! [NSArray]
    }
}
