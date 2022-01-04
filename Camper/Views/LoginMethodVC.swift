//
//  LoginVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit

class LoginMethodVC: UIViewController {
    
    @IBOutlet var kakaoLoginBtn: CamperViewButton!
    @IBOutlet var appleLoginBtn: CamperViewButton!
    @IBOutlet var emailLoginBtn: CamperViewButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupViews(){
        title = "로그인"
        setupNavigationBar()
        
        kakaoLoginBtn.delegate = self
        kakaoLoginBtn.rounded()
        
        appleLoginBtn.delegate = self
        appleLoginBtn.rounded()
        
        emailLoginBtn.delegate = self
        emailLoginBtn.roundedFull()
    }
    
    private func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "close-icon"), style: .plain, target: self, action: #selector(dismissView))
    }
    
    @objc private func dismissView(){
        dismiss(animated: true, completion: nil)
    }
}

extension LoginMethodVC: CamperButtonDelegate{
    func didButtonClicked(_ sender: CamperViewButton) {
        switch sender {
        case kakaoLoginBtn:
            break
        case appleLoginBtn:
            break
        case emailLoginBtn:
            let loginEmailVC = LoginEmailVC()
            navigationController?.pushViewController(loginEmailVC, animated: true)
            break
        default:
            break
        }
    }
}
