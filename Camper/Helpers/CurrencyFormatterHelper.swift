//
//  NumberFormatter.swift
//  Camper
//
//  Created by Filbert Hartawan on 03/01/22.
//

import Foundation

class CurrencyFormatterHelper {
    static func formatCurrency(price: Int) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        let number = NSNumber(value: price)
        return formatter.string(from: number) ?? ""
    }
}
