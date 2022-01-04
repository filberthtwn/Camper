//
//  AppDelegate.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit
import Firebase
import SVProgressHUD
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Configure Firebase
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navVC: UINavigationController = UINavigationController(rootViewController: FeedsVC())
        navVC.modalPresentationStyle = .fullScreen
        navVC.isNavigationBarHidden = true
        self.window!.rootViewController = navVC
        self.window!.makeKeyAndVisible()
        
        NavbarHelper.setup()

        /// Setup IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [SendInquiryVC.self, AddCommentVC.self]
        
        /// Setup SVProgressHUD
        SVProgressHUD.setDefaultMaskType(.black)
        
        /// Register Unauthorized Listener
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NotificationName.LOGOUT, object: nil)
        
        return true
    }
    
    @objc private func logout(){
        UserDefaultHelper.shared.deleteCurrentUser()
        DialogHelper.shared.showError(errorMsg: Message.UNAUTHORIZED) {
            let navVC = UINavigationController(rootViewController: LoginMethodVC())
            navVC.isNavigationBarHidden = true
            navVC.modalPresentationStyle = .fullScreen
            self.window?.rootViewController?.present(navVC, animated: true, completion: nil)
        }
    }
}

