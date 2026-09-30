//
//  FPLCacheTests.swift
//  SeeClearTests
//
//  Created by Mohit Gupta on 30/09/26.
//

//
//  FPLCacheTests.swift
//  SeeClearTests
//
//  Created by Mohit Gupta on 30/09/26.
//

import XCTest
@testable import SeeClear

final class FPLCacheTests:
    XCTestCase {

    private var cacheURL: URL!

    override func setUp() {

        super.setUp()

        cacheURL =
            FileManager.default.temporaryDirectory
                .appendingPathComponent(
                    "fpl_cache_test_\(UUID().uuidString).json"
                )
    }

    override func tearDown() {

        try? FileManager.default.removeItem(
            at: cacheURL
        )

        cacheURL = nil

        super.tearDown()
    }

    func testSaveAndLoadCache() throws {

        let cache =
            FPLCache(
                fileURL: cacheURL
            )

        let team =
            FPLTeam(
                id: 1,
                name: "Arsenal",
                shortName: "ARS",
                code: 3
            )

        let player =
            FPLPlayer(
                id: 10,
                firstName: "Bukayo",
                secondName: "Saka",
                team: 1,
                elementType: 3,
                nowCost: 100,
                totalPoints: 50
            )

        let response =
            FPLResponse(
                teams: [team],
                players: [player]
            )

        try cache.save(response)

        let loaded =
            try cache.load()

        XCTAssertEqual(
            loaded,
            response
        )
    }

    func testMissingCacheReturnsNil()
        throws {

        let cache =
            FPLCache(
                fileURL: cacheURL
            )

        let result =
            try cache.load()

        XCTAssertNil(result)
    }

    func testClearCache() throws {

        let cache =
            FPLCache(
                fileURL: cacheURL
            )

        let response =
            FPLResponse(
                teams: [],
                players: []
            )

        try cache.save(response)
        try cache.clear()

        let result =
            try cache.load()

        XCTAssertNil(result)
    }
}
