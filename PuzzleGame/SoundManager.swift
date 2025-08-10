//
//  SoundManager.swift
// Lil Artist
//
//  Created by Tarun Jain on 07/03/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

enum SoundEffects: String {
    case BgSound            = "bgSound"
    case Success            = "success"
    case Flip               = "flip"
    case Fail               = "fail"
    case Storybg1           = "storybg1"
    case Storybg2           = "storybg2"
    case Storybg3           = "storybg3"
    case Storybg6           = "storybg6"
    case PageTurn           = "pageTurn"
    case PointAdd           = "pointAdd"
    case ButtonTap          = "buttonTap"
    case InCorrect          = "incorrect"
    case Correct            = "correct"
    case GreatJob           = "greatjob"
    case Intro              = "Intro"
    case SmallNumber        = "smallNumber"
    case BigNumber          = "bigNumber"
    case Tap                = "tap"
    case matchCard          = "matchthecard"
    case traceTheLetter     = "traceTheLetter"
    case balloonPop         = "balloonPop"
    case fantasy            = "fantasy"
    case move               = "move"
}

enum NarationSound : String {
    case Narration1  = "storybg7"
}

class SoundManager {
    
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var playOnceAudioPlayer: AVAudioPlayer?
    
    public func play(sound: SoundEffects, volume : Float = 0.4) {
        if let asset = NSDataAsset(name: sound.rawValue) {
            do {
                // Use NSDataAsset's data property to access the audio file stored in Sound.
                audioPlayer = try AVAudioPlayer(data: asset.data, fileTypeHint: nil)
                audioPlayer?.prepareToPlay()
                audioPlayer?.volume = volume
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }
    
    func isPlaying() -> Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    func playOnlyOnce(sound: SoundEffects) {
        guard let asset = NSDataAsset(name: sound.rawValue) else {return}
        do {
            playOnceAudioPlayer = try AVAudioPlayer(data: asset.data, fileTypeHint: nil)
            playOnceAudioPlayer?.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func addHapticFeedback(feedbackType : UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(feedbackType)
    }
    
    func addHapticFeedbackWithStyle(style : UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
}
