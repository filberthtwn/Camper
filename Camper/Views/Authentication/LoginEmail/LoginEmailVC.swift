//
//  LoginEmailVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit
import RxSwift
import RxCocoa

class LoginEmailVC: UIViewController {

    @IBOutlet var emailTF: CamperTextField!
    @IBOutlet var passwordTF: CamperTextField!
    
    @IBOutlet var loginBtn: CamperButton!
    @IBOutlet var registerBtn: CamperButton!
    
    private var authVM = AuthVM()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    private func setupViews(){
        title = "로그인"
        hideKeyboardWhenTappedAround()
        emailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func observeViewModel(){
        authVM.successMsg.bind{(successMsg) in
            self.loginBtn.hideLoading()
            
            let feedsVC = FeedsVC()
            let navVC = UINavigationController(rootViewController: feedsVC)
            navVC.modalPresentationStyle = .fullScreen
            navVC.isNavigationBarHidden = true
            self.present(navVC, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        authVM.errorMsg.bind{(errorMsg) in
            self.loginBtn.hideLoading()
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        loginBtn.isUserInteractionEnabled = (emailTF.text != "" && passwordTF.text != "")
        loginBtn.backgroundColor = (emailTF.text != "" && passwordTF.text != "") ? UIColor(named: "apple-bg") : UIColor.lightGray
    }

    @IBAction func loginAction(_ sender: Any) {
        let email = emailTF.text!
        let password = passwordTF.text!
        
        loginBtn.showLoading()
        authVM.login(email: email, password: password, fcmToken: "123")
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let agreementChecklistVC = AgreementChecklistVC()
        navigationController?.pushViewController(agreementChecklistVC, animated: true)
    }
    
    @IBAction func recoverIDAction(_ sender: Any) {
        let recoverID = RecoverIdVC()
        navigationController?.pushViewController(recoverID, animated: true)
    }
    
    @IBAction func recoverPasswordAction(_ sender: Any) {
        let recoverPasswordVC = RecoverPasswordVC()
        navigationController?.pushViewController(recoverPasswordVC, animated: true)
    }
}
