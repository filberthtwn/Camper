//
//  SettingVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 22/11/21.
//

import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet var editProfileL: UILabel!
    @IBOutlet var privacySettingL: UILabel!
    @IBOutlet var sendInquiryL: UILabel!
    
    @IBOutlet var editProfileBtn: CamperViewButton!
    @IBOutlet var privacySettingBtn: CamperViewButton!
    @IBOutlet var alarmSettingBtn: CamperViewButton!
    @IBOutlet var publicNoticeBtn: CamperViewButton!
    @IBOutlet var faqBtn: CamperViewButton!
    @IBOutlet var sendInquiryBtn: CamperViewButton!
    @IBOutlet var serviceAgreementBtn: CamperViewButton!
    @IBOutlet var privacyAgreementBtn: CamperViewButton!
    @IBOutlet var terminateBtn: CamperViewButton!
    @IBOutlet var logoutBtn: CamperViewButton!
    
    @IBOutlet var versionL: UILabel!
    
    @IBOutlet var terminateV: UIView!
    @IBOutlet var logoutV: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        title = "설정"
        
        editProfileBtn.delegate = self
        privacySettingBtn.delegate = self
        alarmSettingBtn.delegate = self
        publicNoticeBtn.delegate = self
        faqBtn.delegate = self
        sendInquiryBtn.delegate = self
        serviceAgreementBtn.delegate = self
        privacyAgreementBtn.delegate = self
        terminateBtn.delegate = self
        logoutBtn.delegate = self
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"], let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionL.text = "\(version) (\(build))"
        }
        
        if UserDefaultHelper.shared.getCurrentUser() == nil {
            editProfileBtn.isUserInteractionEnabled = false
            editProfileL.textColor = .separator
            privacySettingBtn.isUserInteractionEnabled = false
            privacySettingL.textColor = .separator
            sendInquiryBtn.isUserInteractionEnabled = false
            sendInquiryL.textColor = .separator
            terminateV.isHidden = true
            logoutV.isHidden = true
        }
    }
}

extension SettingVC: CamperButtonDelegate{
    func didButtonClicked(_ sender: CamperViewButton) {
        var rootVC: UIViewController?
            
        switch sender {
        case editProfileBtn:
            rootVC = EditProfileVC()
        case privacySettingBtn:
            rootVC = PrivacySettingVC()
        case alarmSettingBtn:
            rootVC = AlarmSettingVC()
        case publicNoticeBtn:
            rootVC = PublicNoticeVC()
        case faqBtn:
            rootVC = FAQVC()
        case sendInquiryBtn:
            rootVC = SendInquiryVC()
        case serviceAgreementBtn:
            rootVC = AgreementDetailVC()
            (rootVC as! AgreementDetailVC).type = SystemString.Variant.SERVICE_USAGE_AGREEMENT
            rootVC!.title = Title.SERVICE_USAGE_AGREEMENT
        case privacyAgreementBtn:
            rootVC = AgreementDetailVC()
            (rootVC as! AgreementDetailVC).type = SystemString.Variant.PRIVACY_AGREEMENT
            rootVC!.title = Title.PRIVACY_AGREEMENT
        case terminateBtn:
            rootVC = TerminateVC()
        case logoutBtn:
            UserDefaultHelper.shared.deleteCurrentUser()
            let navVC = UINavigationController(rootViewController: FeedsVC())
            navVC.isNavigationBarHidden = true
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true, completion: nil)
            return
        default:
            break
        }
        
        navigationController?.pushViewController(rootVC!, animated: true)
    }
}
