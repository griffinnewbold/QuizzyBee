//
//  textToSpeech.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/24.
//

import AVFoundation
import Combine

class textToSpeech: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?
    
    func speak(_ text: String) {
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        currentUtterance = utterance
        synthesizer.speak(utterance)
    }
    
    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
