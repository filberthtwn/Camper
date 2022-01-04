//
//  NicknameFormVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit
import RxSwift

class NicknameFormVC: UIViewController {

    @IBOutlet var nicknameTF: CamperTextField!
    
    @IBOutlet var finishBtn: CamperButton!
    
    @IBOutlet var warningL: UILabel!
    
    private var authVM = AuthVM()
    private var disposeBag = DisposeBag()
    private var state: AuthState = .REGISTER
    private var message: String?
    
    var email:String?
    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    private func setupViews(){
        title = "회원가입"
        hideKeyboardWhenTappedAround()
        nicknameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func observeViewModel(){
        authVM.successMsg.bind{(successMsg) in
            self.finishBtn.hideLoading()
            
            if self.state == .REGISTER{
                self.state = .LOGIN
                self.message = successMsg
                self.authVM.login(email: self.email!, password: self.password!, fcmToken: "123")
                return
            }
            
            DialogHelper.shared.showSuccess(message: self.message) {
                let feedsVC = FeedsVC()
                let navVC = UINavigationController(rootViewController: feedsVC)
                navVC.modalPresentationStyle = .fullScreen
                navVC.isNavigationBarHidden = true
                self.present(navVC, animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
        
        authVM.errorMsg.bind{(errorMsg) in
            self.finishBtn.hideLoading()
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    private func checkNickname() -> Bool{
        let nicknameRegex = "[A-Z0-9a-z._]*"
        let nicknamePred = NSPredicate(format:"SELF MATCHES %@", nicknameRegex)
        return nicknamePred.evaluate(with: nicknameTF.text!)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        finishBtn.isUserInteractionEnabled = false
        finishBtn.backgroundColor = UIColor.lightGray
        warningL.isHidden = true
        
        if (nicknameTF.text!.count > 0
            && (nicknameTF.text!.count < 2 || nicknameTF.text!.count > 15)
            || !checkNickname()){
            warningL.text = "2~15자의 영소문자, 숫자, 특수문자( . _ )만 사용해주세요."
            warningL.isHidden = false
            return
        }
        
        if nicknameTF.text!.count == 0{
            return
        }
        
        finishBtn.isUserInteractionEnabled = true
        finishBtn.backgroundColor = UIColor(named: "apple-bg")
    }
    
    @IBAction func finishAction(_ sender: Any) {
        finishBtn.showLoading()
        
        guard let email = email, let password = password else { return }
        authVM.register(email: email, password: password, nickname: nicknameTF.text!)
    }
}
