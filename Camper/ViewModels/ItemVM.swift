//
//  ItemVM.swift
//  Camper
//
//  Created by Filbert Hartawan on 30/12/21.
//

import Foundation
import SwiftyJSON
import RxSwift

class ItemVM {
    let itemResp:PublishSubject<ItemResp> = PublishSubject()
    let successMsg:PublishSubject<String> = PublishSubject()
    let errorMsg:PublishSubject<String> = PublishSubject()
    
    func createNewItem(name: String, brandName: String, price: String, link:String){
        let url = "/api/v1/items/create"
        let params:[String:Any] = [
            "name": name,
            "brand_name": brandName,
            "price": Int(price)!,
            "link": link
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
                    let message = json["message"].stringValue
                    let isSuccess = json["success"].boolValue

                    if !isSuccess {
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
    
    func getAllItems(limit: Int, page: Int, search: String){
        let url = "/api/v1/items"
        let params:[String:Any] = [
            "pageSize": limit,
            "pageNo": page,
            "search": search
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

                    let itemResp = try JSONDecoder().decode(ItemResp.self, from: try json["data"].rawData())
                    self.itemResp.onNext(itemResp)
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
