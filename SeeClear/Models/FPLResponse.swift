//
//  FPLResponse.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import Foundation

struct FPLResponse: Codable, Equatable {
    let teams: [FPLTeam]
    let players: [FPLPlayer]

    enum CodingKeys: String, CodingKey {
        case teams
        case players = "elements"
    }
}
