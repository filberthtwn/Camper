//
//  PrivacySettingDetailVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 23/11/21.
//

import UIKit
import SVProgressHUD
import RxSwift

class PrivacySettingDetailVC: UIViewController {

    @IBOutlet var settingBtns: [CamperViewButton]!
    @IBOutlet var checkIcons: [UIImageView]!
    
    private var selectedIndex = 0
    private var message = ""
    private let userVM = UserVM()
    private let disposeBag = DisposeBag()
    
    var delegate: PrivacySettingDelegate?
    var variant: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    private func setupViews(){
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
        
        switch variant! {
            case PrivacySetting.Variant.FEED:
                checkIcons[currentUser.settingFeeds].isHidden = false
                break
            case PrivacySetting.Variant.SCRAP:
                checkIcons[currentUser.settingScraps].isHidden = false
                break
            case PrivacySetting.Variant.ITEM:
                checkIcons[currentUser.settingTaggedItems].isHidden = false
                break
            default:
                break
        }
    }
    
    private func observeViewModel(){
        userVM.successMsg.bind{ (successMsg) in
            self.message = successMsg
            self.userVM.getUserDetail()
        }.disposed(by: disposeBag)
        
        userVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
}

extension PrivacySettingDetailVC: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {
        selectedIndex = sender.tag
        for checkIcon in checkIcons {
            checkIcon.isHidden = true
        }
        checkIcons[selectedIndex].isHidden = false
        userVM.updatePrivacySetting(type: variant!, code: selectedIndex)
        delegate?.didUpdatePrivacySetting(variant: variant!, code: selectedIndex)
    }
}
