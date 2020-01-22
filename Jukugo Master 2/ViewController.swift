//
//  ViewController.swift
//  Jukugo Master 2
//
//  Created by Gerald F. Shields Jr. on 5/14/19.
//  Copyright © 2019 Gerald F. Shields Jr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let controller:GameController
    
    required init?(coder aDecoder: NSCoder) {
        controller = GameController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add one layer for all game elements
        let gameView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        self.view.addSubview(gameView)
        controller.gameView = gameView
        
        //add one view for all HUD and controls
        let hudView = HUDView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        self.view.addSubview(hudView)
        controller.hud = hudView
        
        controller.onCompoundsSolved = self.showLevelMenu
    }
    
    //show the game menu on app start
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showLevelMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func showLevelMenu() {
        //1 show the level selector menu
        let alertController = UIAlertController(title: "Choose Difficulty Level",
                                                message: nil,
                                                preferredStyle:UIAlertController.Style.alert)
        
        //2 set up the menu actions
        let nouns = UIAlertAction(title: "Nouns", style:.default,
                                  handler: {(alert:UIAlertAction!) in
                                    self.showLevel(levelNumber: 1)
        })
        let adjectives = UIAlertAction(title: "Adjectives", style:.default,
                                       handler: {(alert:UIAlertAction!) in
                                        self.showLevel(levelNumber: 2)
        })
        let verbAdverb = UIAlertAction(title: "Verbs and Adverbs", style: .default,
                                       handler: {(alert:UIAlertAction!) in
                                        self.showLevel(levelNumber: 3)
        })
        
        //let purchaseJLPTPack = UIAlertAction(title: "Purchase JLPT Packs", style: default, handler: {(alert:UIAlertAction!) in self.showLevelMenu()})
        
        //3 add the menu actions to the menu
        alertController.addAction(nouns)
        alertController.addAction(adjectives)
        alertController.addAction(verbAdverb)
        
        //4 show the UIAlertController
        self.present(alertController, animated: true, completion: nil)
    }
    
    //5 show the appropriate level selected by the player
    func showLevel(levelNumber:Int) {
        controller.level = Level(levelNumber: levelNumber)
        controller.dealRandomCompounds()
    }
    
}
