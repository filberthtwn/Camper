//
//  ItemTagCVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 27/12/21.
//

import UIKit

class ItemTagCVCell: UICollectionViewCell {

    @IBOutlet var itemIV: UIImageView!
    @IBOutlet var itemNameL: UILabel!
    @IBOutlet var brandNameL: UILabel!
    @IBOutlet var itemPriceL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with item: Item){
        itemNameL.text = item.name
        brandNameL.text = item.brandName
        itemPriceL.text = "\(CurrencyFormatterHelper.formatCurrency(price: item.price))원"
        
        if let imageURL = URL(string: "\(Network.ASSET_URL)\(item.imageUrl)"){
            itemIV.af.setImage(withURL: imageURL, placeholderImage: UIImage())
        }
    }
}
