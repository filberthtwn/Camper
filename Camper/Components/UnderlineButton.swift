//
//  UnderlineButton.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import Foundation
import UIKit

class UnderlineButton: UIButton{
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.black,
        .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let attributeString = NSMutableAttributedString(
            string: title(for: .normal) ?? "",
            attributes: attributes
        )
        setAttributedTitle(attributeString, for: .normal)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
