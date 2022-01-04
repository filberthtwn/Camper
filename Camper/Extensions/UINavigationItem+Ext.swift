//
//  CustomNavigationController.swift
//  Camper
//
//  Created by Filbert Hartawan on 18/12/21.
//

import Foundation
import UIKit

extension UINavigationItem: CamperButtonDelegate {
    func showDismissIcon(){
        let view = CamperViewButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        view.delegate = self
        let dismissIV = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        dismissIV.image = UIImage(named: "close-icon")
        view.addSubview(dismissIV)
        leftBarButtonItem = UIBarButtonItem(customView: view)
    }
    
    func showRightButton(target: UIViewController, title: String, do function: Selector){
        let nextBtn = UIButton()
        nextBtn.setTitle(title, for: .normal)
        nextBtn.setTitleColor(UIColor(named: "primary-text"), for: .normal)
        nextBtn.addTarget(target, action: function, for: .touchUpInside)
        rightBarButtonItem = UIBarButtonItem(customView: nextBtn)
    }
    
    func didButtonClicked(_ sender: CamperViewButton) {
        var currentVC = UIApplication.shared.windows.first?.rootViewController?.presentedViewController
        if let childVC = currentVC?.presentedViewController{
            currentVC = childVC
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
}


