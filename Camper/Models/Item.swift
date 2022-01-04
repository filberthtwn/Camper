//
//  Item.swift
//  Camper
//
//  Created by Filbert Hartawan on 30/12/21.
//

import Foundation

class Item: Codable{
    var id:Int = -1
    var name: String = ""
    var brandName: String = ""
    var price: Int = 0
    var imageUrl: String = ""
    var description: String = ""
    var link: String = ""
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case name = "name"
        case brandName = "brandName"
        case price = "price"
        case imageUrl = "imageUrl"
        case description = "description"
        case link = "link"
    }
}

class ItemResp: Codable {
    var currentPage: Int = 0
    var totalItems: Int = 0
    var totalPages: Int = 0
    var items: [Item] = []
    
    enum CodingKeys:String, CodingKey {
        case currentPage = "currentPage"
        case totalItems = "totalItems"
        case totalPages = "totalPages"
        case items = "data"
    }
}
