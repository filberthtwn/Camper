//
//  GeneralVM.swift
//  Camper
//
//  Created by Filbert Hartawan on 04/12/21.
//

import Foundation
import SwiftyJSON
import RxSwift

class GeneralVM {
    let popups:PublishSubject<[Popup]> = PublishSubject()
    let content:PublishSubject<String> = PublishSubject()
    let errorMsg:PublishSubject<String> = PublishSubject()
    
    func getAllPopup(){
        let url = "/api/v1/popup"
        let params:[String:Any] = [:]
        BaseVM().get(url: url, params: params, isPrivate: false) { (status, data, error) -> (Void) in
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
                    
                    let faqs = try JSONDecoder().decode([Popup].self, from: try json["data"]["popup"].rawData())
                    self.popups.onNext(faqs)
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
    
    func getSystemString(type: String){
        let url = "/api/v1/open/\(type)"
        let params:[String:Any] = [:]
        BaseVM().get(url: url, params: params, isPrivate: false) { (status, data, error) -> (Void) in
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
                    
                    self.content.onNext(json["data"]["data"].stringValue)
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
