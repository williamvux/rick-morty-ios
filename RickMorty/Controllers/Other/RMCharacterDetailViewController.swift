//
//  RMCharacterDetailViewController.swift
//  RickMorty
//
//  Created by William Vux on 07/01/2024.
//

import UIKit

class RMCharacterDetailViewController: UIViewController {
    
    public func initData(viewModel: RMCharacterDetailVM) {
        self.title = viewModel.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = viewModel.title
        view.backgroundColor = .systemBackground

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
