//
//  RMCharactoerViewController.swift
//  RickMorty
//
//  Created by William Vux on 31/12/2023.
//

import UIKit

final class RMCharacterViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = CharacterListViewVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        collectionView.register(
            RMCharactersCollectionViewCell.nib(),
            forCellWithReuseIdentifier: RMCharactersCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            RMFooterLoadingCollectionReusableView.nib(),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier
        )
        let layout  = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 30) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        collectionView.collectionViewLayout = layout
        viewModel.delegate = self
        viewModel.fetchCharacters()
    }
    
}

extension RMCharacterViewController: RMCharaterListViewVMDelegate {
    func didSelectCharacter(_ character: RMCharacter) {
        let viewModel = RMCharacterDetailVM(character: character)
        let storyboard = UIStoryboard(name: "RMCharacterDetailViewController", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "RMCharacterDetailView") as! RMCharacterDetailViewController
        detailVC.initData(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func didLoadInitialCharaters() {
        collectionView.reloadData()
        spinner.stopAnimating()
        collectionView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: newIndexPaths)
        }
    }
    
}
