//
//  AgreementChecklistVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit

class AgreementChecklistVC: UIViewController {
    
    @IBOutlet var agreeAllBtn: CamperViewButton!
    @IBOutlet var ageBtn: CamperViewButton!
    @IBOutlet var serviceBtn: CamperViewButton!
    @IBOutlet var privacyBtn: CamperViewButton!
    @IBOutlet var marketingBtn: CamperViewButton!
    
    @IBOutlet var agreeAllCheckIV: UIImageView!
    @IBOutlet var ageCheckIV: UIImageView!
    @IBOutlet var serviceCheckIV: UIImageView!
    @IBOutlet var privacyCheckIV: UIImageView!
    @IBOutlet var marketingCheckIV: UIImageView!
    
    @IBOutlet var nextBtn: UIButton!
    
    private var isAgreeAllCheck = false
    private var isAgeCheck = false
    private var isServiceCheck = false
    private var isPrivacyCheck = false
    private var isMarketingCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        title = "회원가입"
        
        agreeAllBtn.delegate = self
        ageBtn.delegate = self
        serviceBtn.delegate = self
        privacyBtn.delegate = self
        marketingBtn.delegate = self
    }
    
    
    @IBAction func moveToServicePage(_ sender: Any) {
        let agreementDetailVC = AgreementDetailVC()
        agreementDetailVC.type = SystemString.Variant.SERVICE_USAGE_AGREEMENT
        agreementDetailVC.title = Title.SERVICE_USAGE_AGREEMENT
        navigationController?.pushViewController(agreementDetailVC, animated: true)
    }
    
    @IBAction func moveToPrivacyPage(_ sender: Any) {
        let agreementDetailVC = AgreementDetailVC()
        agreementDetailVC.type = SystemString.Variant.PRIVACY_AGREEMENT
        agreementDetailVC.title = Title.PRIVACY_AGREEMENT
        navigationController?.pushViewController(agreementDetailVC, animated: true)
    }
    
    @IBAction func moveToMarketingPage(_ sender: Any) {
        let agreementDetailVC = AgreementDetailVC()
        agreementDetailVC.type = SystemString.Variant.MARKETING_AGREEMENT
        agreementDetailVC.title = Title.MARKETING_AGREEMENT
        navigationController?.pushViewController(agreementDetailVC, animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let emailFormVC = EmailFormVC()
        navigationController?.pushViewController(emailFormVC, animated: true)
    }
    
}

extension AgreementChecklistVC: CamperButtonDelegate{
    func didButtonClicked(_ sender: CamperViewButton) {
        switch sender {
        case agreeAllBtn:
            setAllCheck(isCheck: !isAgreeAllCheck)
            break
        case ageBtn:
            setAgeCheck(isCheck: !isAgeCheck)
            break
        case serviceBtn:
            setServiceCheck(isCheck: !isServiceCheck)
            break
        case privacyBtn:
            setPrivacyCheck(isCheck: !isPrivacyCheck)
            break
        case marketingBtn:
            setMarketingCheck(isCheck: !isMarketingCheck)
            break
        default:
            break
        }
        
        checkAllAgreeCheck()
    }
    
    private func setAllCheck(isCheck: Bool){
        isAgreeAllCheck = isCheck
        
        setAgeCheck(isCheck: isCheck)
        setServiceCheck(isCheck: isCheck)
        setPrivacyCheck(isCheck: isCheck)
        setMarketingCheck(isCheck: isCheck)
        
        agreeAllCheckIV.tintColor = isAgreeAllCheck ? UIColor(named: "primary-text") : UIColor.lightGray
    }
    
    private func setAgeCheck(isCheck: Bool){
        isAgeCheck = isCheck
        ageCheckIV.tintColor = isAgeCheck ? UIColor(named: "primary-text") : UIColor.lightGray
    }
    
    private func setServiceCheck(isCheck: Bool){
        isServiceCheck = isCheck
        serviceCheckIV.tintColor = isServiceCheck ? UIColor(named: "primary-text") : UIColor.lightGray
    }
    
    private func setPrivacyCheck(isCheck: Bool){
        isPrivacyCheck = isCheck
        privacyCheckIV.tintColor = isPrivacyCheck ? UIColor(named: "primary-text") : UIColor.lightGray
    }
    
    private func setMarketingCheck(isCheck: Bool){
        isMarketingCheck = isCheck
        marketingCheckIV.tintColor = isMarketingCheck ? UIColor(named: "primary-text") : UIColor.lightGray
        
    }
    
    private func checkAllAgreeCheck(){
        if isAgeCheck, isServiceCheck, isPrivacyCheck, isMarketingCheck {
            setAllCheck(isCheck: true)
            nextBtn.backgroundColor = UIColor(named: "apple-bg")
            nextBtn.isUserInteractionEnabled = true
            return
        }
        
        isAgreeAllCheck = false
        agreeAllCheckIV.tintColor = UIColor.lightGray
        nextBtn.backgroundColor = UIColor.lightGray
        nextBtn.isUserInteractionEnabled = false
    }
}
