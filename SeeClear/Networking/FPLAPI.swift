//
//  FPLAPI.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import Foundation

protocol FPLAPIProtocol {
    func fetchBootstrap() async throws -> FPLResponse
}

final class FPLAPI: FPLAPIProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    private let endpoint =
        "https://fantasy.premierleague.com/api/bootstrap-static"

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func fetchBootstrap() async throws -> FPLResponse {

        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }

            do {
                return try decoder.decode(FPLResponse.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }

        } catch let error as NetworkError {
            throw error

        } catch let urlError as URLError {

            switch urlError.code {
            case .notConnectedToInternet,
                 .networkConnectionLost,
                 .dataNotAllowed:

                throw NetworkError.noInternet

            default:
                throw NetworkError.unknown
            }

        } catch {
            throw NetworkError.unknown
        }
    }
}
