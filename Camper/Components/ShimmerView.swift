//
//  ShimmerRoundedFullView.swift
//  Camper
//
//  Created by Filbert Hartawan on 04/12/21.
//

import Foundation
import Shimmer
import UIKit

class ShimmerView: FBShimmeringView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        self.shimmeringSpeed = 500
        self.isShimmering = true
    }
}
