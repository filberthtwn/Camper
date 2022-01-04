//
//  FaqVM.swift
//  Camper
//
//  Created by Filbert Hartawan on 04/12/21.
//

import Foundation
import SwiftyJSON
import RxSwift

class FaqVM {
    let faqResp:PublishSubject<FAQResp> = PublishSubject()
    let errorMsg:PublishSubject<String> = PublishSubject()
    
    func getAllFAQ(limit: Int, page: Int){
        let url = "/api/v1/faq"
        let params:[String:Any] = [
            "pageSize": limit,
            "pageNo": page
        ]
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
                    
                    let faqs = try JSONDecoder().decode(FAQResp.self, from: try json["data"].rawData())
                    self.faqResp.onNext(faqs)
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
