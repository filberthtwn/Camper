//
//  PrivacySetting.swift
//  Camper
//
//  Created by Filbert Hartawan on 01/12/21.
//

import Foundation

struct PrivacySetting {
    struct Variant {
        static let FEED = "feed"
        static let SCRAP = "scrap"
        static let ITEM = "item"
    }
    
    struct Code{
        static let PUBLIC = 0
        static let FOLLOWERS_ONLY = 1
        static let PRIVATE = 2
    }
}
