//
//  Category.swift
//  Camper
//
//  Created by Filbert Hartawan on 05/12/21.
//

import Foundation

class Category: Codable {
    var id:Int = -1
    var name: String = ""
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
