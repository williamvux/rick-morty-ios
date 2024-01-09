//
//  RMCharaterCollectionViewCellVM.swift
//  RickMorty
//
//  Created by William Vux on 04/01/2024.
//

import Foundation

final class RMCharaterCollectionViewCellVM {
    public let characterName: String
    private let characterStatus: RMCharacterStatus
    private let charaterImgUrl: URL?
    init(
        characterName: String,
        characterStatus: RMCharacterStatus,
        charaterImgUrl: URL?
    ) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.charaterImgUrl = charaterImgUrl
    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = charaterImgUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
}
