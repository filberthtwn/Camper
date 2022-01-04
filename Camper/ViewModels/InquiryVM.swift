//
//  InquiryVM.swift
//  Camper
//
//  Created by Filbert Hartawan on 04/12/21.
//

import Foundation
import SwiftyJSON
import RxSwift

class InquiryVM {
    let successMsg:PublishSubject<String> = PublishSubject()
    let errorMsg:PublishSubject<String> = PublishSubject()
    
    func getAllTopics(){
        let url = "/api/v1/settings/inquiry-topics"
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
                    
//                    let faqs = try JSONDecoder().decode([FAQ].self, from: try json["data"]["faq"].rawData())
//                    self.faqs.onNext(faqs)
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
    
    func sendInquiry(topicId: Int, content: String){
        let url = "/api/v1/settings/send-inquiry"
        let params:[String:Any] = [
            "topic_id": topicId,
            "content": content
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
