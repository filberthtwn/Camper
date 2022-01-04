//
//  RoundedView.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import Foundation
import UIKit

class RoundedView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 10
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
