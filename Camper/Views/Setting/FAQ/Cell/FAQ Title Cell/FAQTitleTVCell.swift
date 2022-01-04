//
//  FAQTitleTVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import UIKit

class FAQTitleTVCell: UITableViewCell {

    
    @IBOutlet var categoryL: UILabel!
    @IBOutlet var orderL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(faq: FAQ, index: Int){
        categoryL.text = faq.category
        orderL.text = "FAQ\(index)"
    }
    
}
