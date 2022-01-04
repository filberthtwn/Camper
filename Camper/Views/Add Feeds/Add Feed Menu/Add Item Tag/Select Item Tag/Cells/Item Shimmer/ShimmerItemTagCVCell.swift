//
//  ShimmerSelectItemCVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 30/12/21.
//

import UIKit

class ShimmerItemTagCVCell: UICollectionViewCell {

    @IBOutlet var shimmerV: ShimmerView!
    @IBOutlet var contentV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shimmerV.contentView = contentV
    }

}
