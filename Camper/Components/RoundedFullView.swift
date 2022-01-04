//
//  RoundedFullView.swift
//  Camper
//
//  Created by Filbert Hartawan on 04/12/21.
//

import Foundation
import UIKit

class RoundedFullView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
//    override func layoutSubviews() {
//        layer.cornerRadius = layer.frame.height/2
//    }
    
    private func setup(){
        layer.cornerRadius = layer.frame.height/2
    }
}
