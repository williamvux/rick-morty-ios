//
//  RMCharacterDetailVM.swift
//  RickMorty
//
//  Created by William Vux on 07/01/2024.
//

import Foundation

final class RMCharacterDetailVM {
    private let character: RMCharacter
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
