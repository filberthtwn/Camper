//
//  UIViewController+Ext.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        if let titleView = navigationItem.titleView{
            titleView.endEditing(true)
        }
        view.endEditing(true)
    }
}
