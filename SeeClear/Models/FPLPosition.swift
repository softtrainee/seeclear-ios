//
//  FPLPosition.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import Foundation

enum FPLPosition: Int, CaseIterable {
    case goalkeeper = 1
    case defender = 2
    case midfielder = 3
    case forward = 4

    var title: String {
        switch self {
        case .goalkeeper:
            return "Goalkeepers"

        case .defender:
            return "Defenders"

        case .midfielder:
            return "Midfielders"

        case .forward:
            return "Forwards"
        }
    }

    init?(elementType: Int) {
        self.init(rawValue: elementType)
    }
}
