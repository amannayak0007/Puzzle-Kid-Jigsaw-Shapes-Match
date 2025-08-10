//
//  VoiceManager.swift
//  LoloLearns
//
//  Created by Peyton Shetler on 6/15/22.
//

import Foundation
import AVFoundation

enum LanguageCode: String {
    case english = "en-US"
}

class VoiceManager: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var utteranceQueue: [AVSpeechUtterance] = []

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        // Adjusting the rate to sound more natural (you can experiment with the rate value)
        utterance.rate = 0.4  // Slow down the speaking rate
        // Using the default voice for a more natural sound
        utterance.preUtteranceDelay = 0
        utterance.voice = AVSpeechSynthesisVoice(language: LanguageCode.english.rawValue)
        utteranceQueue.append(utterance)
        speakNextUtteranceIfNeeded()
    }


    private func speakNextUtteranceIfNeeded() {
        if !synthesizer.isSpeaking, !utteranceQueue.isEmpty {
            let nextUtterance = utteranceQueue.removeFirst()
            synthesizer.speak(nextUtterance)
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speakNextUtteranceIfNeeded()
    }
}
