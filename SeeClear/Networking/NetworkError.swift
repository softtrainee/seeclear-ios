//
//  NetworkError.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError
    case noInternet
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."

        case .invalidResponse:
            return "The server returned an invalid response."

        case .serverError(let statusCode):
            return "The server returned status code \(statusCode)."

        case .decodingError:
            return "The server response could not be decoded."

        case .noInternet:
            return "No internet connection is available."

        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
