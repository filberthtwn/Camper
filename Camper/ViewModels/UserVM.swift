//
//  UserVM.swift
//  Camper
//
//  Created by Filbert Hartawan on 01/12/21.
//

import Foundation
import SwiftyJSON
import AlamofireImage
import RxSwift
import UIKit

class UserVM {
    let user:PublishSubject<User> = PublishSubject()
    let followingsFollowers:PublishSubject<FollowingFollowersResp> = PublishSubject()
    let successMsg:PublishSubject<String> = PublishSubject()
    let errorMsg:PublishSubject<String> = PublishSubject()
    let isFollowSuccess:PublishSubject<Bool> = PublishSubject()
    let isUnfollowSuccess:PublishSubject<Bool> = PublishSubject()
    let isDeleteSuccess:PublishSubject<Bool> = PublishSubject()
    
    func getUserDetail(){
        let url = "/api/v1/settings/profile"
        let params:[String:Any] = [:]
        BaseVM().get(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    let user = try JSONDecoder().decode(User.self, from: try json["data"]["user"].rawData())
                    UserDefaultHelper.shared.setupCurrentUser(user)
                    
                    /// Alamofire remove all images from cache
                    UIImageView.af.sharedImageDownloader.imageCache?.removeAllImages()
                    
                    self.user.onNext(user)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
    
    func getOtherUserDetail(nickname: String = ""){
        let url = "/api/v1/user/\(nickname)"
        let params:[String:Any] = [:]
        
        BaseVM().get(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    let user = try JSONDecoder().decode(User.self, from: try json["data"]["user"].rawData())
                    
                    /// Alamofire remove all images from cache
                    UIImageView.af.sharedImageDownloader.imageCache?.removeAllImages()
                    
                    self.user.onNext(user)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
    
    func updateUserDetail(user: User, profilePicture:UIImage?){
        let url = "/api/v1/settings/profile"
        let params:[String:Any] = [
            "nickname": user.nickname,
            "name": user.name ?? "",
            "intro": user.intro ?? ""
        ]
        var images:[String:UIImage] = [:]
        
        if let profilePicture = profilePicture {
            images["profile_picture"] = profilePicture
        }
        
        BaseVM().upload(url: url, method: .patch, params: params, images: images, isPrivate: true) { status, data, error in
            switch status {
            case .SUCCESS:
                    guard let data = data else {
                        self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                        return
                    }
                    
                    do{
                        let json = try JSON(data: data)
                        let isSuccess = json["success"].boolValue

                        if !isSuccess {
                            let message = json["message"].stringValue
                            self.errorMsg.onNext(message)
                            return
                        }
                        
                        self.successMsg.onNext(json["message"].stringValue)
                    }catch(let err){
                        print(err)
                        self.errorMsg.onNext(err.localizedDescription)
                    }
                    return
                case .FAILURE:
                    self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    break
            }
        }
    }
    
    func updatePrivacySetting(type: String, code: Int){
        let url = "/api/v1/settings/privacy"
        let params:[String:Any] = [
            "type": type,
            "code": code
        ]
        
        BaseVM().patch(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    self.successMsg.onNext(json["message"].stringValue)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
    
    func updateFollowerCheck(isAllowance: Bool){
        let url = "/api/v1/settings/follower"
        let params:[String:Any] = [
            "allowance": isAllowance
        ]
        BaseVM().patch(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    self.successMsg.onNext(json["message"].stringValue)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
    
    func updateAlarmSetting(type: String, isAllowance: Bool){
        let url = "/api/v1/settings/alarm"
        let params:[String:Any] = [
            "type": type,
            "allowance": isAllowance
        ]
        BaseVM().patch(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    self.successMsg.onNext(json["message"].stringValue)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
    
    func terminateAccount(){
        let url = "/api/v1/settings/terminate"
        let params:[String:Any] = [:]
        
        BaseVM().post(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    UserDefaultHelper.shared.deleteCurrentUser()
                    self.successMsg.onNext(json["message"].stringValue)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
    
    func getAllFollowingFollowers(state: FollowingFollowersState, limit: Int, page: Int, searchQuery: String){
        let url = (state == .FOLLOWERS) ? "/api/v1/my/followers" : "/api/v1/my/followings"
        let params:[String:Any] = [
            "pageSize": limit,
            "pageNo": page,
            "search": searchQuery
        ]
        BaseVM().get(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    let followings = try JSONDecoder().decode(FollowingFollowersResp.self, from: try json["data"].rawData())
                    self.followingsFollowers.onNext(followings)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
    
    func getAllOtherFollowingFollowers(state: FollowingFollowersState, nickname: String, limit: Int, page: Int, searchQuery: String){
        let url = (state == .FOLLOWERS) ? "/api/v1/user/\(nickname)/followers" : "/api/v1/user/\(nickname)/followings"
        let params:[String:Any] = [
            "pageSize": limit,
            "pageNo": page,
            "search": searchQuery
        ]
        BaseVM().get(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    let followings = try JSONDecoder().decode(FollowingFollowersResp.self, from: try json["data"].rawData())
                    self.followingsFollowers.onNext(followings)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
    
    func unfollowUser(userId: Int){
        let url = "/api/v1/my/unfollow-user"
        let params:[String:Any] = [
            "userId": userId
        ]
        BaseVM().post(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    self.isUnfollowSuccess.onNext(true)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
    
    func followUser(userId: Int){
        let url = "/api/v1/my/follow-user"
        let params:[String:Any] = [
            "userId": userId
        ]
        BaseVM().post(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    self.isFollowSuccess.onNext(true)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
    
    func deleteFollower(userId: Int){
        let url = "/api/v1/my/delete-follower"
        let params:[String:Any] = [
            "userId": userId
        ]
        BaseVM().post(url: url, params: params, isPrivate: true) { (status, data, error) -> (Void) in
            switch status {
            case .SUCCESS:
                guard let data = data else {
                    self.errorMsg.onNext(Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                    return
                }
                
                do{
                    let json = try JSON(data: data)
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
                        let message = json["message"].stringValue
                        self.errorMsg.onNext(message)
                        return
                    }
                    
                    self.isDeleteSuccess.onNext(true)
                }catch(let err){
                    print(err)
                    self.errorMsg.onNext(err.localizedDescription)
                }
                return
            case .FAILURE:
                self.errorMsg.onNext(error ?? Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                break
            }
        }
    }
}
