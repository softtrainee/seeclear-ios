//
//  PlayerSearchTests.swift
//  SeeClearTests
//
//  Created by Mohit Gupta on 30/09/26.
//

import XCTest
@testable import SeeClear

final class PlayerSearchTests:
    XCTestCase {

    @MainActor private func makeViewModel()
        -> SquadViewModel {

        let team =
            FPLTeam(
                id: 1,
                name: "Arsenal",
                shortName: "ARS",
                code: 3
            )

        let players = [
            FPLPlayer(
                id: 1,
                firstName: "Bukayo",
                secondName: "Saka",
                team: 1,
                elementType: 3,
                nowCost: 100,
                totalPoints: 50
            ),

            FPLPlayer(
                id: 2,
                firstName: "Martin",
                secondName: "Odegaard",
                team: 1,
                elementType: 3,
                nowCost: 90,
                totalPoints: 45
            )
        ]

        return SquadViewModel(
            team: team,
            players: players
        )
    }

    @MainActor func testSearchFiltersPlayers() {

        let viewModel =
            makeViewModel()

        viewModel.updateSearchText(
            "saka"
        )

        XCTAssertEqual(
            viewModel.filteredPlayers.count,
            1
        )

        XCTAssertEqual(
            viewModel.filteredPlayers.first?.fullName,
            "Bukayo Saka"
        )
    }

    @MainActor func testEmptySearchReturnsAllPlayers() {

        let viewModel =
            makeViewModel()

        viewModel.updateSearchText("")

        XCTAssertEqual(
            viewModel.filteredPlayers.count,
            2
        )
    }

    @MainActor func testSearchIsCaseInsensitive() {

        let viewModel =
            makeViewModel()

        viewModel.updateSearchText(
            "BUKAYO"
        )

        XCTAssertEqual(
            viewModel.filteredPlayers.count,
            1
        )
    }
}
