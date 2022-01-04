//
//  FAQ.swift
//  Camper
//
//  Created by Filbert Hartawan on 04/12/21.
//

import Foundation
import SwiftyJSON

class FAQ: Codable {
    var id:Int = -1
    var answer: String = ""
    var question: String = ""
    var category: String = ""
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case answer = "answer"
        case question = "question"
        case category = "category"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        self.id = id
        
        let answer = try container.decode(String.self, forKey: .answer)
        self.answer = answer
        
        let question = try container.decode(String.self, forKey: .question)
        self.question = question
        
        let category = try container.decode(FAQCategory.self, forKey: .category)
        self.category = category.name
    }
}

class FAQCategory: Codable {
    var id:Int = -1
    var name: String = ""
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

class FAQResp: Codable {
    var currentPage: Int = 0
    var totalItems: Int = 0
    var totalPages: Int = 0
    var faqs: [FAQ] = []
    
    enum CodingKeys:String, CodingKey {
        case currentPage = "currentPage"
        case totalItems = "totalItems"
        case totalPages = "totalPages"
        case faqs = "data"
    }
}
