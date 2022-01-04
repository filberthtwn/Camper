//
//  BaseVM.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import Foundation
import Alamofire
import SwiftyJSON

enum RequestMethod{
    case post
    case get
    case patch
    case upload
    case delete
}

class BaseVM {
    private var maxRetryCount = 1
    private var loadCount = 0
    
    func post(url:String, params:[String:Any], isPrivate: Bool, completion:@escaping(_ status: NetworkStatus, _ data:Data?,_ error:String?)->Void){
        
        if !(NetworkReachabilityManager()?.isReachable ?? false){
            DispatchQueue.main.async {
                completion(NetworkStatus.FAILURE, nil, Message.NO_INTERNET_CONNECTION)
            }
            return
        }
        
        var headers:HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if isPrivate {
            guard let accessToken = UserDefaultHelper.shared.getAccessToken() else {
                completion(.FAILURE, nil, Message.UNAUTHORIZED)
                return
            }
            headers = ["Authorization": String.init(format: "Bearer %@", accessToken)]
        }
        
        let stringURL = String(format: "%@%@", arguments: [Network.BASE_URL, url])
        print(stringURL)
        
        AF.request(stringURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
            self.handleResponse(url: url, isPrivate: isPrivate, method: .get, response: response, params: params, completion: completion)
        }
    }
    
    func patch(url:String, params:[String:Any], isPrivate: Bool, completion:@escaping(_ status: NetworkStatus, _ data:Data?,_ error:String?)->Void){
        
        if !(NetworkReachabilityManager()?.isReachable ?? false){
            DispatchQueue.main.async {
                completion(NetworkStatus.FAILURE, nil, Message.NO_INTERNET_CONNECTION)
            }
            return
        }
        
        var headers:HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if isPrivate {
            guard let accessToken = UserDefaultHelper.shared.getAccessToken() else {
                completion(.FAILURE, nil, Message.UNAUTHORIZED)
                return
            }
            headers = ["Authorization": String.init(format: "Bearer %@", accessToken)]
        }
        
        let stringURL = String(format: "%@%@", arguments: [Network.BASE_URL, url])
        print(stringURL)
        
        AF.request(stringURL, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
            self.handleResponse(url: url, isPrivate: isPrivate, method: .get, response: response, params: params, completion: completion)
        }
    }
    
    func get(url:String, params:[String:Any], isPrivate: Bool, completion:@escaping(_ status: NetworkStatus, _ data:Data?,_ error:String?)->Void){
        
        if !(NetworkReachabilityManager()?.isReachable ?? false){
            DispatchQueue.main.async {
                completion(NetworkStatus.FAILURE, nil, Message.NO_INTERNET_CONNECTION)
            }
            return
        }
        
        var headers:HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if isPrivate {
            guard let accessToken = UserDefaultHelper.shared.getAccessToken() else {
                completion(.FAILURE, nil, Message.UNAUTHORIZED)
                return
            }
            headers = ["Authorization": String.init(format: "Bearer %@", accessToken)]
        }
        
        let stringURL = String(format: "%@%@", arguments: [Network.BASE_URL, url])
        print(stringURL)
        
        AF.request(stringURL, method: .get, parameters: params, headers: headers).responseData { (response) in
            self.handleResponse(url: url, isPrivate: isPrivate, method: .get, response: response, params: params, completion: completion)
        }
    }
    
    func upload(url:String, method:HTTPMethod, params:[String:Any], images:[String: UIImage], isPrivate: Bool, completion:@escaping(_ status: NetworkStatus, _ data:Data?,_ error:String?)->Void){
        
        if !(NetworkReachabilityManager()?.isReachable ?? false){
            DispatchQueue.main.async {
                completion(NetworkStatus.FAILURE, nil, Message.NO_INTERNET_CONNECTION)
            }
            return
        }
        
        var headers:HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if isPrivate {
            guard let accessToken = UserDefaultHelper.shared.getAccessToken() else {
                completion(.FAILURE, nil, Message.UNAUTHORIZED)
                return
            }
            headers = ["Authorization": String.init(format: "Bearer %@", accessToken)]
        }
        
        let stringURL = String(format: "%@%@", arguments: [Network.BASE_URL, url])
        print(stringURL)
        
        AF.upload(multipartFormData: { (multipartFromData) in
            for (key, image) in images{
                multipartFromData.append(image.jpegData(compressionQuality: 0.25)!, withName: key, fileName: "file.jpeg",mimeType: "image/jpeg")
            }
            
            for param in params{
                multipartFromData.append(Data((param.value as! String).utf8), withName: param.key)
            }
            
        }, to: stringURL,
                  usingThreshold: UInt64.init(),
                  method: method,
                  headers: headers).responseData{ response in
            self.handleResponse(url: url, isPrivate: isPrivate, method: RequestMethod.upload, uploadMethod: method, response: response, params: params, images: images, completion: completion)
        }
    }
    
    func handleResponse(url:String, isPrivate: Bool, method: RequestMethod, uploadMethod: HTTPMethod = .post, response: AFDataResponse<Data>, params: [String: Any], images:[String: UIImage]? = nil, completion: @escaping(_ status: NetworkStatus, _ data:Data?,_ error:String?)->Void){
        do{
            guard let data = response.data else {
                completion(NetworkStatus.FAILURE, nil, Message.THERE_IS_A_PROBLEM_WITH_THE_SERVER)
                return
            }
            let parsedData = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
            
            guard let request = response.request else {return}
            
            print(request)
            print(params)
            
            /// PRETTY PRINT JSON RESPONSE
            let jsonData = try JSONSerialization.data(withJSONObject: parsedData, options: .prettyPrinted)
            print(String(decoding: jsonData, as: UTF8.self))
            
            switch response.result{
            case .success:
                let json = try JSON(data: data)
                if json["error"].stringValue == NetworkError.UNAUTHORIZED{
                    self.refreshToken() {
                        self.recallRequest(url: url, params: params, isPrivate: isPrivate, method: method, uploadMethod: uploadMethod, images: images, completion: completion)
                    }
                    return
                }
                completion(NetworkStatus.SUCCESS, response.data, nil)
            case .failure(let error):
                print(error)
                if error.isSessionTaskError{
                    self.loadCount = self.loadCount + 1
                    if self.loadCount < self.maxRetryCount{
                        self.recallRequest(url: url, params: params, isPrivate: isPrivate, method: method, uploadMethod: uploadMethod, images: images, completion: completion)
                    }else{
                        completion(NetworkStatus.FAILURE, nil, error.localizedDescription)
                    }
                }else{
                    completion(NetworkStatus.FAILURE, nil, error.localizedDescription)
                }
            }
            
        }catch (let error){
            print(error)
            completion(NetworkStatus.FAILURE, nil, error.localizedDescription)
        }
    }
    
    func recallRequest(url:String, params:[String:Any], isPrivate: Bool, method: RequestMethod, uploadMethod: HTTPMethod = .post, images:[String: UIImage]? = nil, completion: @escaping(_ status: NetworkStatus, _ data:Data?,_ error:String?)->Void){
        switch method {
            case .post:
                self.post(url: url, params: params, isPrivate: isPrivate, completion: completion)
            case .get:
                self.get(url: url, params: params, isPrivate: isPrivate, completion: completion)
            case .patch:
                self.patch(url: url, params: params, isPrivate: isPrivate, completion: completion)
            case .upload:
                self.upload(url: url, method: uploadMethod, params: params, images: images!, isPrivate: isPrivate, completion: completion)
            default:
                break
        }
    }
    
    func refreshToken(  completion: @escaping() -> Void){
        let url = "/api/v1/auth/refresh-token"
        let params = [
            "refresh_token": UserDefaultHelper.shared.getRefreshToken() ?? "",
            "token": UserDefaultHelper.shared.getAccessToken() ?? ""
        ]
        post(url: url, params: params, isPrivate: false) { status, data, error in
            do{
                guard let data = data else { return }
                let json = try JSON(data: data)
                if json["message"].stringValue == NetworkError.INVALID_TOKEN {
                    NotificationCenter.default.post(name: NotificationName.LOGOUT, object: nil, userInfo: nil)
                    return
                }
                completion()
                return
            }catch{
                NotificationCenter.default.post(name: NotificationName.LOGOUT, object: nil, userInfo: nil)
                return
            }
        }
    }
}
