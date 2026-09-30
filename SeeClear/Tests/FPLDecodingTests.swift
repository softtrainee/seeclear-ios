//
//  FPLDecodingTests.swift
//  SeeClearTests
//
//  Created by Mohit Gupta on 30/09/26.
//

import XCTest
@testable import SeeClear

final class FPLDecodingTests: XCTestCase {

    func testDecodesTeamsAndPlayers() throws {

        let json = """
        {
            "teams": [
                {
                    "id": 1,
                    "name": "Arsenal",
                    "short_name": "ARS",
                    "code": 3
                }
            ],
            "elements": [
                {
                    "id": 10,
                    "first_name": "Bukayo",
                    "second_name": "Saka",
                    "team": 1,
                    "element_type": 3,
                    "now_cost": 100,
                    "total_points": 50
                }
            ]
        }
        """

        let data =
            Data(json.utf8)

        let response =
            try JSONDecoder().decode(
                FPLResponse.self,
                from: data
            )

        XCTAssertEqual(
            response.teams.count,
            1
        )

        XCTAssertEqual(
            response.players.count,
            1
        )

        XCTAssertEqual(
            response.teams.first?.name,
            "Arsenal"
        )

        XCTAssertEqual(
            response.players.first?.fullName,
            "Bukayo Saka"
        )

        XCTAssertEqual(
            response.players.first?.totalPoints,
            50
        )
    }
}
