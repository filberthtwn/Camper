//
//  Int+Ext.swift
//  Camper
//
//  Created by Filbert Hartawan on 06/12/21.
//

import Foundation

extension Int {
    var shorted: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(floor(million*10)/10)m"
        }
        else if thousand >= 1.0 {
            return "\(floor(thousand*10)/10)k"
        }
        else {
            return "\(self)"
        }
    }
}
