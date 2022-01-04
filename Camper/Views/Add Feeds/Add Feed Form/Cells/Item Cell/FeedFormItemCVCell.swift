//
//  FeedFormItemCVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 03/01/22.
//

import UIKit

enum FeedFormItem {
    case CATEGORY
    case TAGGED_PEOPLE
}

protocol FeedFormItemDelegate {
    func didRemoveItem(index: Int, type: FeedFormItem)
}

class FeedFormItemCVCell: UICollectionViewCell {
    @IBOutlet var containerV: UIView!
    
    @IBOutlet var titleL: UILabel!
    
    private var index: Int = 0
    private var type: FeedFormItem = .CATEGORY
    
    var delegate: FeedFormItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup(){
        containerV.layer.cornerRadius = 4
    }
    
    func configure(title: String, index: Int, type: FeedFormItem){
        titleL.text = title
        self.index = index
        self.type = type
    }
    
    @IBAction func removeAction(_ sender: Any) {
        delegate?.didRemoveItem(index: index, type: type)
    }
}
