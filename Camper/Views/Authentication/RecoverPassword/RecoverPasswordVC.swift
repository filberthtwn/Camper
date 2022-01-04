//
//  RecoverPasswordVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit

class RecoverPasswordVC: UIViewController {

    @IBOutlet var authenticateBtn: CamperButton!
    @IBOutlet var emailTF: CamperTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        title = "비밀번호 찾기"
        authenticateBtn.disable()
        emailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        if emailTF.text! == ""{
            authenticateBtn.disable()
        }
        authenticateBtn.enable(bgColor: UIColor(named: "apple-bg")!)
    }
    
    @IBAction func authenticateAction(_ sender: Any) {
        let passwordFormVC = PasswordFormVC()
        passwordFormVC.email = emailTF.text!
        passwordFormVC.state = .RECOVER_PASSWORD
        navigationController?.pushViewController(passwordFormVC, animated: true)
    }
}
