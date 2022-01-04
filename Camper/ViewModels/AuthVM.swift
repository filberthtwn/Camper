//
//  AuthVM.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import Foundation
import SwiftyJSON
import RxSwift

class AuthVM{
    
    let successMsg:PublishSubject<String?> =  PublishSubject()
    let errorMsg:PublishSubject<String?> =  PublishSubject()

    func login(email:String, password:String, fcmToken: String){
        let url = "/api/v1/auth/login"
        let params:[String:Any] = [
            "email": email,
            "password": password,
            "fcm_token": fcmToken,
        ]
        BaseVM().post(url: url, params: params, isPrivate: false) { (status, data, error) -> (Void) in
            
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
                    
                    guard let accessToken = json["data"]["token"].string, let refreshToken = json["data"]["refresh_token"].string else {
                        self.errorMsg.onNext(json["message"].stringValue)
                        return
                    }
                    
                    UserDefaultHelper.shared.setupAccessToken(accessToken)
                    UserDefaultHelper.shared.setupRefreshToken(refreshToken)
                    
                    let user = try JSONDecoder().decode(User.self, from: try json["data"]["user"].rawData())
                    UserDefaultHelper.shared.setupCurrentUser(user)
                    
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
    
    func register(email:String, password:String, nickname: String){
        let url = "/api/v1/auth/register"
        let params:[String:Any] = [
            "email": email,
            "password": password,
            "nickname": nickname
        ]
        BaseVM().post(url: url, params: params, isPrivate: false) { (status, data, error) -> (Void) in
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
    
    func sendEmailVerification(email: String){
        let url = "/api/v1/auth/verify-email"
        let params:[String:Any] = [
            "email": email,
        ]
        BaseVM().post(url: url, params: params, isPrivate: false) { (status, data, error) -> (Void) in
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
                break
            }
        }
    }
    
    func verifyCode(email: String, code: String){
        let url = "/api/v1/auth/verify-code"
        let params:[String:Any] = [
            "email": email,
            "code": code,
        ]
        BaseVM().post(url: url, params: params, isPrivate: false) { (status, data, error) -> (Void) in
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
    
    func recoverPassword(email:String, newPassword:String){
        let url = "/api/v1/auth/recover-password"
        let params:[String:Any] = [
            "email": email,
            "new_password": newPassword
        ]
        BaseVM().post(url: url, params: params, isPrivate: false) { (status, data, error) -> (Void) in
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

}

