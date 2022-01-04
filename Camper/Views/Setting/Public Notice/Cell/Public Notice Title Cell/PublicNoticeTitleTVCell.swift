//
//  PublicNoticeTVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 23/11/21.
//

import UIKit

class PublicNoticeTitleTVCell: UITableViewCell {

    @IBOutlet var titleL: UILabel!
    @IBOutlet var createdAtL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with publicNotice: PublicNotice){
        titleL.text = publicNotice.title
        createdAtL.text = publicNotice.createdAt
    }
    
}
