//
//  ScrappedFeedsVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 22/11/21.
//

import UIKit

class ScrappedFeedsVC: UIViewController {

    @IBOutlet var scrappedFeedsCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        scrappedFeedsCV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

extension ScrappedFeedsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (scrappedFeedsCV.frame.width/2) - 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
}
