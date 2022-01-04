//
//  EmailFormVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit
import FirebaseAuth
import RxSwift

enum EmailVerificationState {
    case SEND_CODE
    case VERIFY_CODE
}

class EmailFormVC: UIViewController {
    
    @IBOutlet var emailTF: CamperTextField!
    @IBOutlet var authCodeTF: CamperTextField!
    
    @IBOutlet var sendAuthCodeBtn: CamperButton!
    @IBOutlet var authenticateBtn: CamperButton!
    
    @IBOutlet var authCodeV: UIView!
    
    private var verifiedEmail: String?
    private let authVM = AuthVM()
    private let disposeBag = DisposeBag()
    private var timer: Timer?
    private var minute:Int = 5
    private var second:Int = 0
    private var state: EmailVerificationState = .SEND_CODE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        authenticateBtn.disable()
        authCodeV.isHidden = true
        invalidateTimer()
        sendAuthCodeBtn.setTitle("인증코드 받기", for: .normal)
        authCodeTF.text = nil
    }
    
    private func setupViews(){
        title = "회원가입"
        hideKeyboardWhenTappedAround()
        emailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        authCodeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func observeViewModel(){
        self.authVM.successMsg.bind{ (successMsg) in
            switch self.state {
                case .SEND_CODE:
                    self.invalidateTimer()
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateBtnTitle), userInfo: nil, repeats: true)
                case .VERIFY_CODE:
                    self.authenticateBtn.hideLoading()
                
                    let passwordFormVC = PasswordFormVC()
                    passwordFormVC.email = self.verifiedEmail
                    passwordFormVC.state = .REGISTER
                    self.navigationController?.pushViewController(passwordFormVC, animated: true)
            }
            
        }.disposed(by: disposeBag)
        
        self.authVM.errorMsg.bind{ (errorMsg) in
            switch self.state {
                case .SEND_CODE:
                    self.sendAuthCodeBtn.hideLoading()
                    self.sendAuthCodeBtn.isUserInteractionEnabled = true
                case .VERIFY_CODE:
                    self.authenticateBtn.hideLoading()
                    self.authenticateBtn.isUserInteractionEnabled = true
            }
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    private func invalidateTimer(){
        if let timer = timer {
            minute = 5
            second = 0
            timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc private func updateBtnTitle(){
        second -= 1
        
        if self.second < 0 {
            second = 59
            minute -= 1
            
            if self.minute < 0{
                second = 59
                minute = 5
                timer!.invalidate()
                sendAuthCodeBtn.setTitle("인증코드 받기", for: .normal)
                return
            }
        }
        
        if minute == 4 && second == 59 {
            sendAuthCodeBtn.hideLoading()
            authenticateBtn.hideLoading()
            sendAuthCodeBtn.isUserInteractionEnabled = true
            authCodeV.isHidden = false
        }
        
        let title = String(format: "인증코드 다시 받기 (%d분 %d초 남음)", minute, second)
        UIView.performWithoutAnimation {
            sendAuthCodeBtn.setTitle(title, for: .normal)
            sendAuthCodeBtn.layoutIfNeeded()
        }
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        switch sender {
        case emailTF:
            sendAuthCodeBtn.setTitle("인증코드 받기", for: .normal)
            sendAuthCodeBtn.hideLoading()
            timer?.invalidate()
            sendAuthCodeBtn.isUserInteractionEnabled = (emailTF.text != "")
            
            /// Hide Authentication Code View
            authCodeV.isHidden = true
            
            /// Clear Auth Code Text Field Text
            authCodeTF.text = ""
            
            /// Disable Authenticate Button
            authenticateBtn.backgroundColor = UIColor.lightGray
            authenticateBtn.isUserInteractionEnabled = false
            
            if emailTF.text == "" {
                /// Disable Send Auth Code Button
                sendAuthCodeBtn.backgroundColor = UIColor.lightGray
                return
            }
            sendAuthCodeBtn.backgroundColor = UIColor(named: "apple-bg")
        case authCodeTF:
            authenticateBtn.isUserInteractionEnabled = (authCodeTF.text != "")
            authenticateBtn.hideLoading()
            
            if authCodeTF.text == "" {
                authenticateBtn.backgroundColor = UIColor.lightGray
                return
            }
            
            authenticateBtn.backgroundColor = UIColor(named: "apple-bg")
        default:
            break
        }
    }
    
    @IBAction func sendAuthAction(_ sender: Any) {
        self.invalidateTimer()
        state = .SEND_CODE
        authCodeV.isHidden = true
        verifiedEmail = emailTF.text!
        sendAuthCodeBtn.isUserInteractionEnabled = false
        sendAuthCodeBtn.showLoading()
        authVM.sendEmailVerification(email: verifiedEmail!)
    }
    
    @IBAction func authenticateAction(_ sender: Any) {
        state = .VERIFY_CODE
        authenticateBtn.isUserInteractionEnabled = false
        authenticateBtn.showLoading()
        authVM.verifyCode(email: verifiedEmail!, code: authCodeTF.text!)
    }
}
