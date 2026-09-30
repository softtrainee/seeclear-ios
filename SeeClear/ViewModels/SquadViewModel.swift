//
//  SquadViewModel.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import Foundation

@MainActor
final class SquadViewModel {

    private let team: FPLTeam
    private let players: [FPLPlayer]

    private(set) var searchText = ""

    init(
        team: FPLTeam,
        players: [FPLPlayer]
    ) {
        self.team = team
        self.players = players
    }

    var title: String {
        team.name
    }

    var filteredPlayers: [FPLPlayer] {

        let teamPlayers =
            players.filter {
                $0.team == team.id
            }

        guard !searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        else {
            return teamPlayers
        }

        let query =
            searchText
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()

        return teamPlayers.filter {

            $0.fullName
                .lowercased()
                .contains(query)
        }
    }

    func updateSearchText(_ text: String) {
        searchText = text
    }

    func players(for position: FPLPosition) -> [FPLPlayer] {

        filteredPlayers
            .filter {
                $0.elementType == position.rawValue
            }
            .sorted {
                if $0.totalPoints == $1.totalPoints {
                    return $0.fullName < $1.fullName
                }

                return $0.totalPoints > $1.totalPoints
            }
    }

    var sections: [FPLPosition] {

        FPLPosition.allCases.filter {
            !players(for: $0).isEmpty
        }
    }

    var isEmpty: Bool {
        filteredPlayers.isEmpty
    }
}
