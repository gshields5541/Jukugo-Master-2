//
//  StopwatchView.swift
//  Jukugo Master
//
//  Created by Gerald F. Shields Jr. on 4/12/19.
//  Copyright © 2019 Gerald Shields. All rights reserved.
//

import Foundation
import UIKit

class StopwatchView: UILabel {
    //this should never be called
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(frame:")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.font = FontHUDBig
    }
    
    //helper method that implements time formatting
    //to an int parameter(eg the seconds left)
    func setSeconds(seconds:Int) {
        self.text = String(format: " %02i : %02i", seconds/60, seconds % 60)
    }
}
