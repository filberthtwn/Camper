//
//  DialogHelper.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import Foundation
import SVProgressHUD

class DialogHelper{
    static let shared = DialogHelper()
    
    private let delay: TimeInterval = 1.25
    
    func showSuccess(message: String?, completion: @escaping() -> Void){
        SVProgressHUD.showSuccess(withStatus: message)
        SVProgressHUD.dismiss(withDelay: delay, completion: completion)
    }
    
    func showError(errorMsg: String?, completion: (() -> Void)? = nil){
        SVProgressHUD.showError(withStatus: errorMsg)
        SVProgressHUD.dismiss(withDelay: delay, completion: completion)
    }
}
