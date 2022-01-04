//
//  PhotoCVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 18/12/21.
//

import UIKit

class PhotoCVCell: UICollectionViewCell {

    @IBOutlet var photoIV: UIImageView!
    @IBOutlet var checkIV: UIImageView!
    
    @IBOutlet var selectIndexL: UILabel!
    
    @IBOutlet var countV: RoundedFullView!
    
    var selectedIndex: Int? {
        didSet {
            selectIndexL.isHidden = selectedIndex == nil
            checkIV.isHidden = selectedIndex != nil
            
            selectIndexL.text = String((selectedIndex ?? 0) + 1)
        }
    }
    
    var isSelect = false {
        didSet {
            photoIV.layer.borderWidth = isSelect ? 4 : 0
            photoIV.layer.borderColor =  isSelect ? UIColor(named: "primary-text")!.cgColor : UIColor.white.cgColor
            
            countV.layer.borderColor =  isSelect ? UIColor(named: "primary-text")!.cgColor : UIColor.white.cgColor
            countV.layer.backgroundColor = isSelect ? UIColor(named: "primary-text")!.cgColor : UIColor.clear.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews(){
        countV.layer.borderWidth = 1
//        countV.layer.backgroundColor = UIColor(named: "primary-text")!.cgColor
    }

}
