//
//  PublicNoticeContentTVCellTableViewCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import UIKit

class PublicNoticeContentTVCell: UITableViewCell {

    @IBOutlet var descriptionL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with publicNotice: PublicNotice){
        descriptionL.text = publicNotice.description
    }
    
}
