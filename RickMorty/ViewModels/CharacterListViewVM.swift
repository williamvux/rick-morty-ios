//
//  CharacterListViewVM.swift
//  RickMorty
//
//  Created by William Vux on 03/01/2024.
//

import UIKit


protocol RMCharaterListViewVMDelegate: AnyObject {
    func didLoadInitialCharaters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}

final class CharacterListViewVM: NSObject {
    private var timer: Timer? = nil
    public weak var delegate: RMCharaterListViewVMDelegate?
    private var isLoadingMoreCharacters = false
    private var characters: [RMCharacter] = []
    
    private var cellViewModel: [RMCharaterCollectionViewCellVM] = []
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    func fetchCharacters() {
        RMService.shared.execute(.listCharacters, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let models):
                let results = models.results
                self?.modifyCharacters(results)
                self?.apiInfo = models.info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharaters()
                }
            case .failure(let failure):
                print(20, String(describing: failure))
            }
        }
    }
    
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("Failed to create request")
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            guard let mSelf = self else {
                return
            }
            switch result {
            case .success(let models):
                let moreCharacters = models.results
                mSelf.apiInfo = models.info
                let originalCount = mSelf.characters.count
                let newCount = moreCharacters.count
                let indexPaths: [IndexPath] = Array(originalCount..<(originalCount + newCount)).compactMap { index in
                    return IndexPath(row: index, section: 0)
                }     
                mSelf.modifyCharacters(moreCharacters)

                DispatchQueue.main.async {
                    mSelf.delegate?.didLoadMoreCharacters(with: indexPaths)
                }
            case .failure(let error):
                print(error)         
            }
            
            self?.isLoadingMoreCharacters = false
        }
    }
    
    private func modifyCharacters(_ arr: [RMCharacter]) {
        characters.append(contentsOf: arr)
        cellViewModel.append(contentsOf: arr.compactMap({ character in
            return RMCharaterCollectionViewCellVM(
                characterName: character.name,
                characterStatus: character.status,
                charaterImgUrl: URL(string: character.image)
            )
        }))
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        apiInfo?.next != nil
    }
    
}

extension CharacterListViewVM: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharactersCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharactersCollectionViewCell else {
            fatalError("UnsupportedCell")
        }
        let viewModel = cellViewModel[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return if shouldShowLoadMoreIndicator {
            CGSize(width: collectionView.frame.width, height: 50)
        } else {
            .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("Unsuported")
        }
        
        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath
        )
        
        return footer
    }
}

extension CharacterListViewVM: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, 
                !isLoadingMoreCharacters,
              let urlStr = apiInfo?.next,
              let url = URL(string: urlStr),
              !cellViewModel.isEmpty
        else {
            return
        }
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            print("timer")
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 150) {
                self?.fetchAdditionalCharacters(url: url)
            }
            timer.invalidate()
        }
    }
}
