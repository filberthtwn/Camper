//
//  PublicNotice.swift
//  Camper
//
//  Created by Filbert Hartawan on 04/12/21.
//

import Foundation

class PublicNotice: Codable {
    var id:Int = -1
    var title: String = ""
    var description: String = ""
    var createdAt: String = ""
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case createdAt = "createdAt"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        self.id = id
        
        let title = try container.decode(String.self, forKey: .title)
        self.title = title
        
        let description = try container.decode(String.self, forKey: .description)
        self.description = description
        
        let createdAt = try container.decode(String.self, forKey: .createdAt)
        self.createdAt = DateformatterHelper.shared.formatISO8601(newDateFormat: "YYYY.MM.dd", dateString: createdAt, timezone: nil)
    }
}

class PublicNoticeResp: Codable {
    var currentPage: Int = 0
    var totalItems: Int = 0
    var totalPages: Int = 0
    var publicNotices: [PublicNotice] = []
    
    enum CodingKeys:String, CodingKey {
        case currentPage = "currentPage"
        case totalItems = "totalItems"
        case totalPages = "totalPages"
        case publicNotices = "data"
    }
}
