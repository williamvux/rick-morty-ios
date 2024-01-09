//
//  RMCharacter.swift
//  RickMorty
//
//  Created by William Vux on 31/12/2023.
//

import Foundation

struct RMCharacter: Codable {
    let id: Int
    let name, species, type: String
    let status: RMCharacterStatus
    let gender: RMCharacterGender
    let origin: RMOrigin
    let location: RMSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
