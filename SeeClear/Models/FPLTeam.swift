//
//  FPLTeam.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import Foundation

struct FPLTeam: Codable, Equatable {
    let id: Int
    let name: String
    let shortName: String
    let code: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
        case code
    }
}
