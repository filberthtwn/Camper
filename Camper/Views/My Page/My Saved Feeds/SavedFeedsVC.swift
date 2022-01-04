//
//  SavedListVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import UIKit

class SavedFeedsVC: UIViewController {

    @IBOutlet var savedFeedsCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        title = "보관된 게시물"
        savedFeedsCV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

extension SavedFeedsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (savedFeedsCV.frame.width/2) - 2
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
