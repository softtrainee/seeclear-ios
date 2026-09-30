//
//  ErrorHandlingTests.swift
//  SeeClearTests
//
//  Created by Mohit Gupta on 30/09/26.
//

import XCTest
@testable import SeeClear

final class ErrorHandlingTests:
    XCTestCase {

    func testNetworkErrorDescriptions() {

        XCTAssertEqual(
            NetworkError.invalidURL.localizedDescription,
            "The API URL is invalid."
        )

        XCTAssertEqual(
            NetworkError.noInternet.localizedDescription,
            "No internet connection is available."
        )

        XCTAssertEqual(
            NetworkError.serverError(500).localizedDescription,
            "The server returned status code 500."
        )

        XCTAssertEqual(
            NetworkError.decodingError.localizedDescription,
            "The server response could not be decoded."
        )
    }
}
