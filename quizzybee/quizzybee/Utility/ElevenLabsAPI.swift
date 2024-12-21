//
//  ElevenLabsAPI.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/26/24.
//

import Foundation

/// A utility class for interacting with the Eleven Labs API.
///
/// - Purpose:
///   - Provides functionality for fetching voices and synthesizing speech.
///   - Handles API requests and responses from the Eleven Labs service.
struct ElevenLabsAPI {
    
    
    
    /// An instance of the ElevenlabsSwift client for managing API requests.
    private static let client = ElevenlabsSwift(elevenLabsAPI: EnvironmentLoader().get("ELEVEN_LABS_KEY")!)

    // MARK: - Fetch Voices

    /// Fetches a list of cloned voices from the Eleven Labs API.
    /// - Returns: An array of `Voice` objects filtered by the "cloned" category.
    /// - Throws: A `WebAPIError` if the API call fails or the response cannot be decoded.
    static func fetchVoices() async throws -> [Voice] {
        let allVoices = try await client.fetchVoices()
        let clonedVoices = allVoices.filter { $0.category == "cloned" }
        return clonedVoices
    }

    // MARK: - Text-to-Speech (TTS)

    /// Synthesizes speech for a given voice ID and text input.
    /// - Parameters:
    ///   - voiceId: The unique identifier for the voice.
    ///   - text: The input text to be converted to speech.
    ///   - model: An optional model for the text-to-speech operation.
    /// - Returns: A URL to the synthesized speech file.
    /// - Throws: A `WebAPIError` if the API call fails or the response cannot be processed.
    static func synthesizeSpeech(voiceId: String, text: String, model: String? = nil) async throws -> URL {
        return try await client.textToSpeech(voice_id: voiceId, text: text, model: model)
    }
}

// MARK: - ElevenlabsSwift Client

/// A client for interacting with the Eleven Labs API.
///
/// - Purpose:
///   - Manages direct API requests for fetching voices and synthesizing speech.
public class ElevenlabsSwift {
    private var elevenLabsAPI: String
    private let baseURL = "https://api.elevenlabs.io"

    /// Initializes the ElevenlabsSwift client.
    /// - Parameter elevenLabsAPI: The API key for Eleven Labs.
    public required init(elevenLabsAPI: String) {
        self.elevenLabsAPI = elevenLabsAPI
    }

    // MARK: - Fetch Voices

    /// Fetches all voices available in the Eleven Labs API.
    /// - Returns: An array of `Voice` objects.
    /// - Throws: A `WebAPIError` if the API call fails or the response cannot be decoded.
    public func fetchVoices() async throws -> [Voice] {
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)/v1/voices")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(elevenLabsAPI, forHTTPHeaderField: "xi-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, _) = try await session.data(for: request)
            let response: VoicesResponse = try JSONDecoder().decode(VoicesResponse.self, from: data)
            return response.voices
        } catch {
            throw WebAPIError.httpError(message: error.localizedDescription)
        }
    }

    // MARK: - Text-to-Speech (TTS)

    /// Synthesizes speech from text using the Eleven Labs API.
    /// - Parameters:
    ///   - voice_id: The unique identifier for the voice.
    ///   - text: The text to synthesize.
    ///   - model: An optional model for the text-to-speech operation.
    /// - Returns: A URL to the synthesized speech file.
    /// - Throws: A `WebAPIError` if the API call fails or the response cannot be processed.
    public func textToSpeech(voice_id: String, text: String, model: String? = nil) async throws -> URL {
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)/v1/text-to-speech/\(voice_id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(elevenLabsAPI, forHTTPHeaderField: "xi-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("audio/mpeg", forHTTPHeaderField: "Accept")

        let parameters = SpeechRequest(text: text, voice_settings: ["stability": 0, "similarity_boost": 0], model: model)

        guard let jsonBody = try? JSONEncoder().encode(parameters) else {
            throw WebAPIError.unableToEncodeJSONData
        }

        request.httpBody = jsonBody

        do {
            let (data, _) = try await session.data(for: request)
            let fileURL = try saveDataToTempFile(data: data)
            return fileURL
        } catch {
            throw WebAPIError.httpError(message: error.localizedDescription)
        }
    }

    // MARK: - Save Data to Temp File

    /// Saves raw data to a temporary file on disk.
    /// - Parameter data: The raw data to save.
    /// - Returns: A URL pointing to the saved file.
    /// - Throws: An error if the data cannot be written to disk.
    private func saveDataToTempFile(data: Data) throws -> URL {
        let tempDirectoryURL = FileManager.default.temporaryDirectory
        let randomFilename = "\(UUID().uuidString).mpg"
        let fileURL = tempDirectoryURL.appendingPathComponent(randomFilename)
        try data.write(to: fileURL)
        return fileURL
    }
}

// MARK: - Web API Errors

/// Enumeration of possible errors during API interaction.
public enum WebAPIError: Error {
    case identityTokenMissing
    case unableToDecodeIdentityToken
    case unableToEncodeJSONData
    case unableToDecodeJSONData
    case unauthorized
    case invalidResponse
    case httpError(message: String)
    case httpErrorWithStatus(status: Int)
}

// MARK: - Voices Response

/// The response structure for fetching voices from the Eleven Labs API.
public struct VoicesResponse: Codable {
    /// An array of `Voice` objects.
    public let voices: [Voice]

    public init(voices: [Voice]) {
        self.voices = voices
    }
}

// MARK: - Voice Model

/// A model representing a voice available in the Eleven Labs API.
public struct Voice: Codable, Identifiable, Hashable {
    /// The unique identifier for the voice.
    public let voice_id: String
    
    /// The name of the voice.
    public let name: String
    
    /// The category of the voice (e.g., "cloned").
    public let category: String
    
    /// Conforms to the `Identifiable` protocol using `voice_id` as the ID.
    public var id: String { voice_id }

    public init(voice_id: String, name: String, category: String) {
        self.voice_id = voice_id
        self.name = name
        self.category = category
    }
}

// MARK: - Speech Request

/// A request body for synthesizing speech via the Eleven Labs API.
public struct SpeechRequest: Codable {
    /// The text to be synthesized.
    public let text: String
    
    /// Voice settings, such as stability and similarity boost.
    public let voice_settings: [String: Int]
    
    /// An optional model for the text-to-speech operation.
    public let model: String?

    public init(text: String, voice_settings: [String: Int], model: String?) {
        self.text = text
        self.voice_settings = voice_settings
        self.model = model
    }
}
