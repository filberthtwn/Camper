//
//  AddCategoryCVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 20/12/21.
//

import UIKit

class AddCategoryCVCell: UICollectionViewCell {

    @IBOutlet var containerV: UIView!
    @IBOutlet var categoryL: UILabel!
    
    var isCategorySelected: Bool = false {
        didSet {
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        containerV.layer.cornerRadius = 4
        containerV.layer.borderWidth = 1
        containerV.layer.borderColor = UIColor.black.cgColor
    }
    
    func configure(category: Category, isSelected: Bool){
        categoryL.text = category.name
        categoryL.textColor = isSelected ? .white : .black
        containerV.backgroundColor = isSelected ? UIColor(named: "primary-text") : .clear
        containerV.layer.borderColor = isSelected ? UIColor(named: "primary-text")!.cgColor : UIColor.black.cgColor
    }
}
