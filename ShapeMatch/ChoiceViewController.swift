//
//  ChoiceViewController.swift
//  educational-game-for-kids
//
//  Created by Flatiron School on 9/10/16.
//  Copyright © 2016 jennyshalai. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SoundManager.shared.stopSound()
    }
    
    
    @IBAction func fruitsImageTapped(_ sender : UIButton) {
        let nextViewController = self.storyboard!.instantiateViewController(withIdentifier: "FruitsViewController")
        nextViewController.modalPresentationStyle = .fullScreen
        SoundManager.shared.addHapticFeedbackWithStyle(style: .medium)
SoundManager.shared.playOnlyOnce(sound: .Tap)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func animalsImageTapped(_ sender : UIButton) {
        let nextViewController = self.storyboard!.instantiateViewController(withIdentifier: "AnimalsViewController")
        nextViewController.modalPresentationStyle = .fullScreen
        SoundManager.shared.addHapticFeedbackWithStyle(style: .medium)
SoundManager.shared.playOnlyOnce(sound: .Tap)
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func didTapShape(_ sender : UIButton) {
        let nextViewController = self.storyboard!.instantiateViewController(withIdentifier: "ShapeViewController")
        nextViewController.modalPresentationStyle = .fullScreen
        SoundManager.shared.addHapticFeedbackWithStyle(style: .medium)
SoundManager.shared.playOnlyOnce(sound: .Tap)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func didTapEmoji(_ sender : UIButton) {
        let nextViewController = self.storyboard!.instantiateViewController(withIdentifier: "EmojiViewController")
        nextViewController.modalPresentationStyle = .fullScreen
        SoundManager.shared.addHapticFeedbackWithStyle(style: .medium)
SoundManager.shared.playOnlyOnce(sound: .Tap)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func didTapPlant(_ sender : UIButton) {
        let nextViewController = self.storyboard!.instantiateViewController(withIdentifier: "PlantViewController")
        nextViewController.modalPresentationStyle = .fullScreen
        SoundManager.shared.addHapticFeedbackWithStyle(style: .medium)
SoundManager.shared.playOnlyOnce(sound: .Tap)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func didTapVehicle(_ sender : UIButton) {
        let nextViewController = self.storyboard!.instantiateViewController(withIdentifier: "VehiclesViewController")
        nextViewController.modalPresentationStyle = .fullScreen
        SoundManager.shared.addHapticFeedbackWithStyle(style: .medium)
SoundManager.shared.playOnlyOnce(sound: .Tap)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func didTapHome(_ sender : UIButton) {
        sender.animateLabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
          self.navigationController?.popViewController(animated: true) 
        }
         SoundManager.shared.addHapticFeedbackWithStyle(style: .rigid)
         SoundManager.shared.playOnlyOnce(sound: .Tap)
    }
}
