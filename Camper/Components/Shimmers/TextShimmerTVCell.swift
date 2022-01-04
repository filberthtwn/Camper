//
//  TextShimmerTVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 04/12/21.
//

import UIKit

class TextShimmerTVCell: UITableViewCell {

    @IBOutlet var shimmerV: ShimmerView!
    @IBOutlet var contentV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shimmerV.contentView = contentV
    }
}
