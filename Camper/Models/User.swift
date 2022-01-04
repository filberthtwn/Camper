//
//  User.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import Foundation

class User: Codable {
    var id: Int = -1
    var name: String?
    var nickname: String = ""
    var email: String = ""
    var profilePicture: String?
    var intro: String?
    var settingFeeds: Int = 0
    var settingScraps:Int = 0
    var settingTaggedItems: Int = 0
    var alarmLike: Bool = false
    var alarmScrap: Bool = false
    var alarmComment: Bool = false
    var alarmMention: Bool = false
    var alarmFollow: Bool = false
    var followerCheck: Bool = false
    var followersCount: Int = 0
    var followingCount: Int = 0
    var isFollowing: Bool?
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case name = "name"
        case nickname = "nickname"
        case email = "email"
        case profilePicture = "profile_picture"
        case intro = "intro"
        case settingFeeds = "setting_feeds"
        case settingScraps = "setting_scraps"
        case settingTaggedItems = "setting_tagged_items"
        case alarmLike = "alarm_likes"
        case alarmScrap = "alarm_scraps"
        case alarmComment = "alarm_comments"
        case alarmMention = "alarm_mentions"
        case alarmFollow = "alarm_follows"
        case followerCheck = "follower_check"
        case followersCount = "total_followers"
        case followingCount = "total_followings"
        case isFollowing = "isFollowing"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        self.id = id
        
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        self.name = name
        
        let nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
        self.nickname = nickname ?? ""
        
        let email = try container.decodeIfPresent(String.self, forKey: .email)
        self.email = email ?? ""
        
        let profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture)
        self.profilePicture = profilePicture
        
        let intro = try container.decodeIfPresent(String.self, forKey: .intro)
        self.intro = (intro != "" && intro != nil) ? intro : "-"
        
        let settingFeeds = try container.decodeIfPresent(Int.self, forKey: .settingFeeds)
        self.settingFeeds = settingFeeds ?? 0
        
        let settingScraps = try container.decodeIfPresent(Int.self, forKey: .settingScraps)
        self.settingScraps = settingScraps ?? 0
        
        let settingTaggedItems = try container.decodeIfPresent(Int.self, forKey: .settingTaggedItems)
        self.settingTaggedItems = settingTaggedItems ?? 0
        
        let alarmLike = try container.decodeIfPresent(Bool.self, forKey: .alarmLike)
        self.alarmLike = alarmLike ?? false
        
        let alarmScrap = try container.decodeIfPresent(Bool.self, forKey: .alarmScrap)
        self.alarmScrap = alarmScrap ?? false
        
        let alarmComment = try container.decodeIfPresent(Bool.self, forKey: .alarmComment)
        self.alarmComment = alarmComment ?? false
        
        let alarmMention = try container.decodeIfPresent(Bool.self, forKey: .alarmMention)
        self.alarmMention = alarmMention ?? false
        
        let alarmFollow = try container.decodeIfPresent(Bool.self, forKey: .alarmFollow)
        self.alarmFollow = alarmFollow ?? false
        
        let followerCheck = try container.decodeIfPresent(Bool.self, forKey: .followerCheck)
        self.followerCheck = followerCheck ?? false
        
        let followersCount = try container.decodeIfPresent(Int.self, forKey: .followersCount)
        self.followersCount = followersCount ?? 0
        
        let followingCount = try container.decodeIfPresent(Int.self, forKey: .followingCount)
        self.followingCount = followingCount ?? 0
        
        self.isFollowing = try container.decodeIfPresent(Bool.self, forKey: .isFollowing)
    }
}

class FollowingFollowersResp:Codable {
    var currentPage: Int = 0
    var totalItems: Int = 0
    var totalPages: Int = 0
    var users: [User] = []
    
    enum CodingKeys:String, CodingKey {
        case currentPage = "currentPage"
        case totalItems = "totalItems"
        case totalPages = "totalPages"
        case users = "data"
    }
}
