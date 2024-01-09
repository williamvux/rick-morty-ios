//
//  RMEpisode.swift
//  RickMorty
//
//  Created by William Vux on 31/12/2023.
//

import Foundation

struct RMEpisode: Codable {
    let id: Int
    let name, air_date, episode: String
    let characters: [String]
    let url: String
    let created: String
}
