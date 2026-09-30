//
//  FPLCache.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import Foundation

protocol FPLCacheProtocol {
    func save(_ response: FPLResponse) throws
    func load() throws -> FPLResponse?
    func clear() throws
}

final class FPLCache: FPLCacheProtocol {

    private let fileManager: FileManager
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        fileManager: FileManager = .default,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileManager = fileManager
        self.encoder = encoder
        self.decoder = decoder

        let documentsDirectory =
            fileManager.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first!

        self.fileURL =
            documentsDirectory.appendingPathComponent("fpl_cache.json")
    }

    init(
        fileURL: URL,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileManager = .default
        self.fileURL = fileURL
        self.encoder = encoder
        self.decoder = decoder
    }

    func save(_ response: FPLResponse) throws {

        let data = try encoder.encode(response)

        try data.write(
            to: fileURL,
            options: [.atomic]
        )
    }

    func load() throws -> FPLResponse? {

        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }

        let data = try Data(contentsOf: fileURL)

        return try decoder.decode(
            FPLResponse.self,
            from: data
        )
    }

    func clear() throws {

        guard fileManager.fileExists(atPath: fileURL.path) else {
            return
        }

        try fileManager.removeItem(at: fileURL)
    }
}
