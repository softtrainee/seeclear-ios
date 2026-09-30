//
//  FPLPlayer.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import Foundation

struct FPLPlayer: Codable, Equatable {
    let id: Int
    let firstName: String
    let secondName: String
    let team: Int
    let elementType: Int
    let nowCost: Int
    let totalPoints: Int

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case secondName = "second_name"
        case team
        case elementType = "element_type"
        case nowCost = "now_cost"
        case totalPoints = "total_points"
    }

    var fullName: String {
        "\(firstName) \(secondName)"
    }

    var price: String {
        String(format: "£%.1fm", Double(nowCost) / 10.0)
    }
}
