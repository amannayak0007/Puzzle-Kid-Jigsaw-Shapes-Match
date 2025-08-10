//
//  GameScene.swift
//  JigsawGame
//
//  Created by Aman Jain on 2020/7/20.
//  Copyright © 2020 Aman JainWeb. All rights reserved.
//

import SpriteKit

class PuzzleGameScene: SKScene {
    
    var sceneName = ""
    
    override func didMove(to view: SKView) {
        if sceneName == "HomeScene" {
            let scene = HomeScene(size: self.scene!.size)
            scene.scaleMode = .aspectFit
            self.view?.presentScene(scene)
        } else if sceneName == "ObjectPuzzleScene" {
            let scene = ObjectPuzzleScene(size: self.scene!.size)
            scene.scaleMode = .aspectFit
            self.view?.presentScene(scene)
        } else {
            let scene = FruitPuzzleScene(size: self.scene!.size)
            scene.scaleMode = .aspectFit
            self.view?.presentScene(scene)
        }
      
    }
    
    func createPlayButton(at position: CGPoint) {
        //Make a play button
        let playButton = SKSpriteNode(imageNamed: "play-icon.png")
        playButton.name = "playBtn"
        playButton.size = CGSize(width: 200, height: 200)
        playButton.position = position
        playButton.blendMode = .alpha
        addChild(playButton)
        
        //Add scaling animation to the button
        let scaleUpAction = SKAction.scale(to: 1.5, duration: 1)
        let scaleDownAction = SKAction.scale(to: 1.3, duration: 1)
        let scaleActionSeq = SKAction.sequence([scaleUpAction, scaleDownAction])
        let scaleForever = SKAction.repeatForever(scaleActionSeq)
        playButton.run(scaleForever)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "playBtn" {
            //print("Play button pressed. Transition to HomeScene(all car images)")
            let scene = HomeScene(size: self.scene!.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene)
          }
        }
    }
}
