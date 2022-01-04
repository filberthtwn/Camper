//
//  FollowerCheckVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 23/11/21.
//

import UIKit
import RxSwift
import SVProgressHUD

class FollowerCheckVC: UIViewController {

    @IBOutlet var settingBtns: [CamperViewButton]!
    @IBOutlet var checkIcons: [UIImageView]!
    
    private var selectedIndex = 0
    private var message = ""
    private let userVM = UserVM()
    private let disposeBag = DisposeBag()
    
    var delegate: PrivacySettingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    private func observeViewModel() {
        userVM.successMsg.bind{ (successMsg) in
            self.message = successMsg
            self.userVM.getUserDetail()
        }.disposed(by: disposeBag)
        
        userVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    private func setupViews(){
        title = "팔로우 수락 검토"
        setupDefaultValue()
        for settingBtn in settingBtns {
            settingBtn.delegate = self
        }
    }
    
    private func setupDefaultValue(){
        guard let currentUser = UserDefaultHelper.shared.getCurrentUser() else { return }
        
        for checkIcon in checkIcons {
            checkIcon.isHidden = true
        }
        
        checkIcons[currentUser.followerCheck ? 1 : 0].isHidden = false
    }
}

extension FollowerCheckVC: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {
        selectedIndex = sender.tag
        for checkIcon in checkIcons {
            checkIcon.isHidden = true
        }
        checkIcons[selectedIndex].isHidden = false
        
        let isAllowance = (selectedIndex == 0) ? false : true
        userVM.updateFollowerCheck(isAllowance: isAllowance)
        delegate?.didUpdateFollowerCheck(followerCheck: isAllowance)
    }
}
