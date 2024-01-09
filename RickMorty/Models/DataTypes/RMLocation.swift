//
//  RMLocation.swift
//  RickMorty
//
//  Created by William Vux on 31/12/2023.
//

import Foundation

struct RMLocation: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}
