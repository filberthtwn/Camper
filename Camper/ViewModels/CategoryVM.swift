//
//  CategoryVM.swift
//  Camper
//
//  Created by Filbert Hartawan on 05/12/21.
//

import Foundation
import SwiftyJSON
import RxSwift

class CategoryVM {
    let categories:PublishSubject<[Category]> = PublishSubject()
    let errorMsg:PublishSubject<String> = PublishSubject()
    
    func getAllCategory(){
        let url = "/api/v1/category"
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
                    
                    let categories = try JSONDecoder().decode([Category].self, from: try json["data"]["categories"].rawData())
                    self.categories.onNext(categories)
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
