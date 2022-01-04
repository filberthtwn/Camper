//
//  PasswordFormVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit
import RxSwift

class PasswordFormVC: UIViewController {

    @IBOutlet var passwordTF: CamperTextField!
    @IBOutlet var confirmPasswordTF: CamperTextField!
    
    @IBOutlet var passwordWarningL: UILabel!
    @IBOutlet var confirmPasswordWarningL: UILabel!
    
    @IBOutlet var nextBtn: CamperButton!
    
    private var authVM = AuthVM()
    private var disposeBag = DisposeBag()
    
    var email:String?
    var state: PasswordFormState = .REGISTER
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    private func setupViews(){
        title = "회원가입"
        hideKeyboardWhenTappedAround()
        passwordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func observeViewModel(){
        authVM.successMsg.bind{(successMsg) in
            self.nextBtn.hideLoading()
            DialogHelper.shared.showSuccess(message: successMsg) {
                let viewControllers = self.navigationController!.viewControllers
                for viewController in viewControllers {
                    if viewController.isKind(of: LoginEmailVC.self){
                        self.navigationController?.popToViewController(viewController, animated: true)
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        authVM.errorMsg.bind{(errorMsg) in
            self.nextBtn.hideLoading()
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        /// Hide/ Show Password Not Match Warning
        confirmPasswordWarningL.isHidden = (confirmPasswordTF.text!.isEmpty || confirmPasswordTF.text! == passwordTF.text!)
        
        /// Disable Next Button
        disableNextBtn()
        
        switch sender {
        case passwordTF:
            passwordWarningL.textColor = UIColor.lightGray
            if passwordTF.text!.count < 9{
                passwordWarningL.textColor = UIColor.red
                return
            }
        case confirmPasswordTF:
            if confirmPasswordTF.text! != passwordTF.text!
                || passwordTF.text!.count < 9 {
                return
            }
        default:
            break
        }
        
        /// Enable  Next Button
        nextBtn.isUserInteractionEnabled = true
        nextBtn.backgroundColor = UIColor(named: "apple-bg")
    }
    
    private func disableNextBtn(){
        nextBtn.isUserInteractionEnabled = false
        nextBtn.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func nextAction(_ sender: Any) {
        /// When current state from RecoverPasswordVC
        if state == .RECOVER_PASSWORD {
            nextBtn.showLoading()
            
            guard let email = email else { return }
            authVM.recoverPassword(email: email, newPassword: passwordTF.text!)
            return
        }
        
        let nicknameFormVC = NicknameFormVC()
        nicknameFormVC.email = email
        nicknameFormVC.password = passwordTF.text!
        navigationController?.pushViewController(nicknameFormVC, animated: true)
    }
}
