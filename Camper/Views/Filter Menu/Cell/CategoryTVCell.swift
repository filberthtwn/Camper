//
//  CategoryTVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 05/12/21.
//

import UIKit

class CategoryTVCell: UITableViewCell {

    @IBOutlet var titleL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(category: Category){
        titleL.text = category.name
    }
    
}
