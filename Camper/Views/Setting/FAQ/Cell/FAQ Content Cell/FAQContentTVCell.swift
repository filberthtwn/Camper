//
//  FAQContentTVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import UIKit

class FAQContentTVCell: UITableViewCell {

    @IBOutlet var questionL: UILabel!
    @IBOutlet var answerL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(faq: FAQ){
        questionL.text = "Q. \(faq.question)"
        answerL.text = "A. \(faq.answer)"
    }
}
