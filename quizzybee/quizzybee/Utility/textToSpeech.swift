//
//  textToSpeech.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/24.
//

import AVFoundation
import Combine

/// A class for managing text-to-speech and audio playback.
///
/// - Purpose:
///   - Converts text into speech using `AVSpeechSynthesizer`.
///   - Plays audio files using `AVAudioPlayer`.
///   - Provides functionality to stop or interrupt ongoing speech playback.
class textToSpeech: ObservableObject {
    /// The speech synthesizer responsible for converting text to speech.
    private let synthesizer = AVSpeechSynthesizer()
    
    /// The currently active speech utterance.
    private var currentUtterance: AVSpeechUtterance?
    
    /// The audio player for playing pre-recorded audio files.
    private var player: AVAudioPlayer?

    // MARK: - Methods
    
    /// Converts the given text into speech.
    ///
    /// - Parameter text: The text to be spoken aloud.
    ///
    /// - Behavior:
    ///   - If speech is already in progress, it stops the current utterance immediately before starting the new one.
    ///   - Configures the speech rate, pitch, volume, and language for the utterance.
    func speak(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5 // Adjusts the speech rate (default: 0.5).
        utterance.pitchMultiplier = 1.0 // Sets the pitch of the speech (default: 1.0).
        utterance.volume = 1.0 // Sets the volume of the speech (default: 1.0).
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Sets the language to English (US).
        
        currentUtterance = utterance
        synthesizer.speak(utterance)
    }

    /// Stops the current speech playback immediately, if any.
    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    /// Plays an audio file from a given URL.
    ///
    /// - Parameter url: The URL of the audio file to be played.
    ///
    /// - Behavior:
    ///   - Prepares the audio player to play the file.
    ///   - Starts audio playback.
    ///   - Logs an error message if the audio file cannot be played.
    func playAudio(from url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
