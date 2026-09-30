//
//  FPLRepository.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import Foundation

protocol FPLRepositoryProtocol {
    func fetch(forceRefresh: Bool) async throws -> FPLResponse
    func loadCached() -> FPLResponse?
}

final class FPLRepository: FPLRepositoryProtocol {

    private let api: FPLAPIProtocol
    private let cache: FPLCacheProtocol

    init(
        api: FPLAPIProtocol,
        cache: FPLCacheProtocol
    ) {
        self.api = api
        self.cache = cache
    }

    func fetch(forceRefresh: Bool) async throws -> FPLResponse {

        do {
            let response = try await api.fetchBootstrap()

            // Cache only successful responses.
            try cache.save(response)

            return response

        } catch {
            throw error
        }
    }

    func loadCached() -> FPLResponse? {

        do {
            return try cache.load()
        } catch {
            return nil
        }
    }
}
