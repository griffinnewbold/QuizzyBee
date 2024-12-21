//
//  EnvironmentLoader.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 12/21/24.
//


import Foundation

class EnvironmentLoader: ObservableObject {
    private var environment: [String: String] = [:]

    init(fileName: String = ".env") {
        loadEnvFile(fileName: fileName)
    }

    private func loadEnvFile(fileName: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            print("Failed to find .env file.")
            return
        }

        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let lines = content.split(separator: "\n")
            for line in lines {
                let parts = line.split(separator: "=", maxSplits: 1)
                guard parts.count == 2 else { continue }
                let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                environment[key] = value
            }
        } catch {
            print("Error reading .env file: \(error)")
        }
    }

    func get(_ key: String) -> String? {
        return environment[key]
    }
}
