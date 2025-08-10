//
//  GameViewController.swift
//  JigsawGame
//
//  Created by AMAN JAIN on 2020/7/20.
//  Copyright © 2020 AMAN JAIN. All rights reserved.
//

import UIKit
import SpriteKit
import StoreKit

var ifAlreadyAskedReview =  false
var defaults = UserDefaults.standard

class PuzzleGameViewController: UIViewController {

    var screenName = ""
    
    fileprivate func rating() {
        if !ifAlreadyAskedReview {
            //Request review
            SKStoreReviewController.requestReview()
            ifAlreadyAskedReview = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "PuzzleGameScene") as? PuzzleGameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.sceneName = screenName
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
        
        SoundManager.shared.stopSound()
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        sender.animateLabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.navigationController?.popViewController(animated: true)
        }
        SoundManager.shared.addHapticFeedbackWithStyle(style: .medium)
        SoundManager.shared.playOnlyOnce(sound: .Tap)
        
        // Ask to rate App
        self.rating()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
