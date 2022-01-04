//
//  TerminateVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 23/11/21.
//

import UIKit
import RxSwift
import SVProgressHUD

class TerminateVC: UIViewController {

    @IBOutlet var checkListContainerV: CamperViewButton!
    @IBOutlet var checklistInnerV: UIView!
    
    @IBOutlet var cancelBtn: CamperButton!
    @IBOutlet var terminateBtn: CamperButton!
    
    private let userVM = UserVM()
    private let disposeBag = DisposeBag()
    private var isAgree = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    private func setupViews(){
        title = "회원 탈퇴"
        checklistInnerV.isHidden = true
        
        checkListContainerV.delegate = self
        checkListContainerV.layer.borderColor = UIColor.lightGray.cgColor
        checkListContainerV.layer.borderWidth = 1
        
        cancelBtn.disable()
    }
    
    private func observeViewModel(){
        userVM.successMsg.bind{ (successMsg) in
            DialogHelper.shared.showSuccess(message: successMsg) {
                let navVC = UINavigationController(rootViewController: FeedsVC())
                navVC.isNavigationBarHidden = true
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
        
        userVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    @IBAction func terminateAction(_ sender: Any) {
        let alert = UIAlertController(title: "정말 탈퇴 하시겠습니까?", message: "탈퇴확인을 누르면 계정 탈퇴가 이루어 집니다. 탈퇴 후 n개월 동안 재가입이 불가합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "탈퇴확인", style: .default, handler: { action in
            SVProgressHUD.show()
            self.userVM.terminateAccount()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


extension TerminateVC: CamperButtonDelegate{
    func didButtonClicked(_ sender: CamperViewButton) {
        isAgree = !isAgree
        checklistInnerV.isHidden = !isAgree
        (isAgree) ? cancelBtn.enable(bgColor: UIColor(named: "apple-bg")!) : cancelBtn.disable()
    }
}
