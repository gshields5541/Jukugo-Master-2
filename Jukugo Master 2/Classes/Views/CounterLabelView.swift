//
//  CounterLabelView.swift
//  Jukugo Master
//
//  Created by Gerald F. Shields Jr. on 4/13/19.
//  Copyright © 2019 Gerald Shields. All rights reserved.
//

import Foundation
import UIKit

class CounterLabelView: UILabel {
    //1
    private var endValue: Int = 0
    private var timer: Timer? = nil
    
    var value:Int = 0 {
        //2
        didSet {
            self.text = " \(value)"
        }
    }
    
    //This should never be called
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(font:frame:")
    }
    
    
    //3
    init(font:UIFont, frame:CGRect){
        super.init(frame:frame)
        self.font = font
        self.backgroundColor = UIColor.clear
    }
    
    @objc func updateValue(timer: Timer) {
        //1 update the value
        if (endValue < value){
            value -= 1
        } else {
            value += 1
        }
        
        //2 stop and clear the timer
        if (endValue == value){
            timer.invalidate()
            self.timer = nil
        }
    }
    
    //count to a given value
    func setValue(newValue:Int, duration:Float) {
        //1 set the end value
        endValue = newValue
        
        //2 cancel previous timer
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        //3 calculate the interval to fire each timer
        let deltaValue = abs(endValue - value)
        if (deltaValue != 0) {
            var interval = Double(duration / Float(deltaValue))
            if interval < 0.01 {
                interval = 0.01
            }
            
            //4 set the timer to update the value
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateValue), userInfo: nil, repeats: true)
        }
    }
}
