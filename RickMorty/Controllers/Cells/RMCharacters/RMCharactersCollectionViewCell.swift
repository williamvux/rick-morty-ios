//
//  RMCharactersCollectionViewCell.swift
//  RickMorty
//
//  Created by William Vux on 04/01/2024.
//

import UIKit

class RMCharactersCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharactersCollectionViewCell"

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var statusTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imgView.image = nil
        nameTxt.text = nil
        statusTxt.text = nil
    }
    
    
    public func configure(with viewModel: RMCharaterCollectionViewCellVM) {
        nameTxt.text = viewModel.characterName
        statusTxt.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imgView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "RMCharactersCollectionViewCell", bundle: nil)
    }
}
