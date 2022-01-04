//
//  Popup.swift
//  Camper
//
//  Created by Filbert Hartawan on 13/12/21.
//

import Foundation

class Popup: Codable{
    var id:Int = -1
    var title: String = ""
    var content: String = ""
    var image: String?
    var link: String?
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case title = "title"
        case content = "content"
        case image = "image"
        case link = "link"
    }
}
