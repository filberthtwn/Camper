//
//  RoundedImageView.swift
//  Camper
//
//  Created by Filbert Hartawan on 22/11/21.
//

import Foundation
import UIKit

class RoundedImageView: UIImageView{
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 10
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
