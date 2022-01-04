//
//  UserShimmerTVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 06/12/21.
//

import UIKit

class UserShimmerTVCell: UITableViewCell {

    @IBOutlet var shimmerV: ShimmerView!
    @IBOutlet var contentV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shimmerV.contentView = contentV
    }
}
