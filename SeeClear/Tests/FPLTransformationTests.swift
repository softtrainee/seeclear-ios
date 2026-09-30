//
//  FPLTransformationTests.swift
//  SeeClearTests
//
//  Created by Mohit Gupta on 30/09/26.
//

import XCTest
@testable import SeeClear

final class FPLTransformationTests:
    XCTestCase {

    @MainActor func testPlayersAreGroupedByTeam() {

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
                firstName: "Player",
                secondName: "One",
                team: 1,
                elementType: 3,
                nowCost: 100,
                totalPoints: 80
            ),

            FPLPlayer(
                id: 2,
                firstName: "Player",
                secondName: "Two",
                team: 2,
                elementType: 3,
                nowCost: 90,
                totalPoints: 70
            )
        ]

        let viewModel =
            SquadViewModel(
                team: team,
                players: players
            )

        XCTAssertEqual(
            viewModel.filteredPlayers.count,
            1
        )

        XCTAssertEqual(
            viewModel.filteredPlayers.first?.id,
            1
        )
    }

    @MainActor func testPlayersAreSortedByTotalPoints() {

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
                firstName: "Low",
                secondName: "Points",
                team: 1,
                elementType: 3,
                nowCost: 80,
                totalPoints: 20
            ),

            FPLPlayer(
                id: 2,
                firstName: "High",
                secondName: "Points",
                team: 1,
                elementType: 3,
                nowCost: 100,
                totalPoints: 80
            )
        ]

        let viewModel =
            SquadViewModel(
                team: team,
                players: players
            )

        let midfielders =
            viewModel.players(
                for: .midfielder
            )

        XCTAssertEqual(
            midfielders.first?.id,
            2
        )

        XCTAssertEqual(
            midfielders.last?.id,
            1
        )
    }
}
