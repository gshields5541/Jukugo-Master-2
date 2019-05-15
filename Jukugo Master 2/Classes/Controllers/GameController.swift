//
//  GameController.swift
//  Jukugo Master
//
//  Created by Gerald F. Shields Jr. on 4/12/19.
//  Copyright © 2019 Gerald Shields. All rights reserved.
//

import Foundation
import UIKit

class GameController {
    var gameView: UIView!
    var level: Level!
    var onCompoundsSolved: ( () -> ())!

    private var tiles = [TileView]()
    private var targets = [TargetView]()
    private var data = GameData()
    
    var hud:HUDView! {
        didSet {
            //connect the Hint button
            hud.hintButton.addTarget(self, action: #selector(actionHint), for:.touchUpInside)
            hud.hintButton.isEnabled = false
        }
    }
    
    //the user pressed the hint button
    @objc func actionHint() {
        //1
        hud.hintButton.isEnabled = true
        
        //2
        data.points -= level.pointsPerTile / 2
        hud.gamePoints.setValue(newValue: data.points, duration: 1.5)
        
        //3
        
        var foundTarget:TargetView? = nil
        for target in targets {
            if !target.isMatched {
                foundTarget = target
                break
            }
        }
        
        //4 find the first tile matching the target
        var foundTile:TileView? = nil
        for tile in tiles  {
            if !tile.isMatched && tile.letter == foundTarget?.letter {
                foundTile = tile
                break
            }
        }
        
        //ensure there is a matching tile and target
        if let target = foundTarget, let tile = foundTile {
            
            //5 don't want the tile sliding under other tiles
            gameView.bringSubviewToFront(tile)
            
            //6 show the animation to the user
            UIView.animate(withDuration: 1.5,
                                       delay:0.0,
                                       options:UIView.AnimationOptions.curveEaseOut,
                                       animations:{
                                        tile.center = target.center
            }, completion: {
                (value:Bool) in
                
                //7 adjust view on spot
                self.placeTile(tileView: tile, targetView: target)
                
                //8 re-enable the button
                self.hud.hintButton.isEnabled = true
                
                //9 check for finished game
                self.checkForSuccess()
                
            })
        }
    }
    
    
    //clear the tiles and targets
    func clearBoard() {
        tiles.removeAll(keepingCapacity: false)
        targets.removeAll(keepingCapacity: false)
        
        for view in gameView.subviews {
            view.removeFromSuperview()
        }
    }
    
    //stopwatch variables
    private var secondsLeft: Int = 0
    private var timer: Timer?
    
    private var audioController: AudioController
    
    init() {
        self.audioController = AudioController()
        self.audioController.preloadAudioEffects(effectFileNames: AudioEffectFiles)
    }
    
    
    
    
    func dealRandomCompounds () {
        //1
        assert(level.compounds.count > 0, "no level loaded")
        
        //2
        let randomIndex = randomNumber(min:0, max:UInt32(level.compounds.count-1))
        let compoundPair = level.compounds[randomIndex]
        
        //3
        let compound1 = compoundPair[0] as! String
        let compound2 = compoundPair[1] as! String
        let compound3 = compoundPair[2] as! String
        
        //4
        let compound1length = compound1.count
        let compound2length = compound2.count
        let compound3length = compound3.count
        
        //5
        print("phrase1[\(compound1length)]: \(compound1)")
        print("phrase2[\(compound2length)]: \(compound2)")
        print("phrase3[\(compound2length)]: \(compound3)")
        
        //calculate the tile size
        let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(max(compound1length, compound2length, compound3length))) - TileMargin
        
        //get the left margin for first tile
        var xOffset = (ScreenWidth - CGFloat(max(compound1length, compound2length, compound3length)) * (tileSide + TileMargin)) / 2.0
        
        //adjust for tile center (instead of the tile's origin)
        xOffset += tileSide / 2.0
        
        //initialize target list
        targets = []
        
        //create targets
        for(index, letter) in compound2.enumerated(){
            //3
            if letter != " "{
                let target = TargetView(letter: letter, sideLength: tileSide)
                target.center = CGPoint(x: xOffset + CGFloat(index)*(tileSide + TileMargin),y: ScreenHeight/4)
                //4
                gameView.addSubview(target)
                targets.append(target)
            }
        }
        //1 initialize tile list
        tiles = []
        
        //2 create tiles
        for (index, letter) in compound1.enumerated() {
            //3
            if letter != " " {
                let tile = TileView(letter: letter, sideLength: tileSide)
                tile.center = CGPoint(x: xOffset + CGFloat(index)*(tileSide + TileMargin), y: ScreenHeight/4*3)
                tile.randomize()
                tile.dragDelegate = self
                
                //4
                gameView.addSubview(tile)
                tiles.append(tile)
            }
        }
        
        //create a list for the meanings of the jukugo
        
        for (index, letter) in compound3.enumerated() {
            //3
            if letter != " " {
                let tile = TileView(letter: letter, sideLength: tileSide)
                tile.center = CGPoint(x: xOffset + CGFloat(index)*(tileSide + TileMargin), y: ScreenHeight/6*3)
                tile.randomize()
                tile.dragDelegate = self
                
                //4
                gameView.addSubview(tile)
                tiles.append(tile)
            }
        }
        
        //start the timer
        self.startStopwatch()
        
        hud.hintButton.isEnabled = true
    }
    
    func placeTile(tileView: TileView, targetView: TargetView) {
        //1
        targetView.isMatched = true
        tileView.isMatched = true
        
        //2
        tileView.isUserInteractionEnabled = false
        
        //3
        UIView.animate(withDuration: 0.35,
                                   delay:0.00,
                                   options:UIView.AnimationOptions.curveEaseOut,
                                   //4
            animations: {
                tileView.center = targetView.center
                tileView.transform = .identity
        },
            //5
            completion: {
                (value:Bool) in
                targetView.isHidden = true
        })
    }
    
    func checkForSuccess(){
        for targetView in targets{
            //no success, bail but
            if !targetView.isMatched{
                return
            }
        }
        print("Game Over")
        
        hud.hintButton.isEnabled = false
        
        //stop the stopwatch
        self.stopStopwatch()
        
        //the compound is completed!
        audioController.playEffect(name: SoundWin)
        
        //win animation
        let firstTarget = targets[0]
        let startX:CGFloat = 0
        let endX:CGFloat = ScreenWidth + 300
        let startY = firstTarget.center.y
        
        let stars = StardustView(frame: CGRect(x: startX, y: startY, width: 10, height: 20))
        gameView.addSubview(stars)
        gameView.sendSubviewToBack(stars)
        
        UIView.animate(withDuration: 3.0,
                                   delay:0.0,
                                   options:UIView.AnimationOptions.curveEaseOut,
                                   animations:{
                                    stars.center = CGPoint(x: endX, y: startY)
        }, completion: {(value:Bool) in
            //game finished
            stars.removeFromSuperview()
            // when animation is finished , show menu
            self.clearBoard()
            self.onCompoundsSolved()
        })
    }
    
    
    func startStopwatch() {
        secondsLeft = level.timeToSolve
        hud.stopwatch.setSeconds(seconds: secondsLeft)
        
        //schedule a new timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    func stopStopwatch() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func tick(timer: Timer) {
        secondsLeft-=1
        hud.stopwatch.setSeconds(seconds: secondsLeft)
        if secondsLeft == 0 {
            self.stopStopwatch()
        }
    }
}


extension GameController:TileDragDelegateProtocol {
    //a tile was dragged, check if matches a target
    func tileView(tileView: TileView, didDragToPoint point: CGPoint) {
        var targetView: TargetView?
        for tv in targets {
            if tv.frame.contains(point) && !tv.isMatched {
                targetView = tv
                break
            }
        }
        
        //1 check if target was found
        if let targetView = targetView {
            //2 check if letter matches
            if targetView.letter == tileView.letter {
                
                //3
                self.placeTile(tileView: tileView, targetView: targetView)
                
                //more stuff to do on success here
                audioController.playEffect(name: SoundDing)
                
                //give points
                data.points += level.pointsPerTile
                hud.gamePoints.setValue(newValue: data.points, duration: 0.5)
                
                //check for finished game
                self.checkForSuccess()
            } else {
                
                //4
                //1
                tileView.randomize()
                
                //2
                UIView.animate(withDuration: 0.35, delay: 0.0,  options: UIView.AnimationOptions.curveEaseOut, animations: {
                    tileView.center = CGPoint(x: tileView.center.x + CGFloat(randomNumber(min:0, max:40)-20),
                                              y: tileView.center.y + CGFloat(randomNumber(min:20, max:30)))
                }, completion: nil)
                
                //more stuff to do on failure here
                audioController.playEffect(name: SoundWrong)
                
                //take out points
                data.points -= level.pointsPerTile/2
                hud.gamePoints.setValue(newValue: data.points, duration: 0.25)
                
                let explode = ExplodeView(frame: CGRect(x: tileView.center.x, y: tileView.center.y, width: 10, height: 10))
                tileView.superview?.addSubview(explode)
                tileView.superview?.sendSubviewToBack(explode)
            }
        }
    }
}
