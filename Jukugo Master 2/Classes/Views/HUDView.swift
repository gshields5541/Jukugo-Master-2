//
//  HUDView.swift
//  Jukugo Master
//
//  Created by Gerald F. Shields Jr. on 4/12/19.
//  Copyright © 2019 Gerald Shields. All rights reserved.
//

import Foundation
import UIKit

class HUDView: UIView {
    
    var stopwatch: StopwatchView
    var gamePoints: CounterLabelView
    var hintButton: UIButton!
    
    //this should never be called
    required init(coder aDecoder:NSCoder) {
        fatalError("use init(frame:")
    }
    
    override init(frame:CGRect) {
        self.stopwatch = StopwatchView(frame:CGRect(x: ScreenWidth/2 - 150, y: 0, width: 300, height: 100))
        self.stopwatch.setSeconds(seconds: 0)
        
        //the dynamic points label
        self.gamePoints = CounterLabelView(font: FontHUD!, frame: CGRect(x: ScreenWidth-200, y: 30, width: 200, height: 70))
        gamePoints.textColor = UIColor(red: 0.38, green: 0.098, blue: 0.035, alpha: 1)
        gamePoints.value = 0
        
        super.init(frame:frame)
        
        self.addSubview(gamePoints)
        let pointsLabel = UILabel(frame: CGRect(x: ScreenWidth-340, y: 30, width: 140, height: 70))
        pointsLabel.backgroundColor = UIColor.clear
        pointsLabel.font = FontHUD
        pointsLabel.text = " Points:"
        self.addSubview(pointsLabel)
        
        self.isUserInteractionEnabled = true
        self.addSubview(self.stopwatch)
        
        //load the button image
        let hintButtonImage = UIImage(named: "btn")!
        
        //the help button
        self.hintButton = UIButton(type: .custom) 
        hintButton.setTitle("Hint!", for:.normal)
        hintButton.titleLabel?.font = FontHUD
        hintButton.setBackgroundImage(hintButtonImage, for: .normal)
        hintButton.frame = CGRect(x: 50, y: 30, width: hintButtonImage.size.width, height: hintButtonImage.size.height)
        hintButton.alpha = 0.8
        self.addSubview(hintButton)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //1 let touches through and only catch the ones on buttons
        let hitView = super.hitTest(point, with: event)
        
        //2
        if hitView is UIButton {
            return hitView
        }
        
        //3
        return nil
    }
}
