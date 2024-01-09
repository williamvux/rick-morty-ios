//
//  RMFooterLoadingCollectionReusableView.swift
//  RickMorty
//
//  Created by William Vux on 07/01/2024.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "RMFooterLoadingCollectionReusableView"
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib() -> UINib {
        return UINib(nibName: "RMFooterLoadingCollectionReusableView", bundle: nil)
    }
    
}
