//
//  AlarmSettingVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 23/11/21.
//

import UIKit
import RxSwift

class AlarmSettingVC: UIViewController {
    
    @IBOutlet var eventSW: UISwitch!
    @IBOutlet var likeSW: UISwitch!
    @IBOutlet var scrapSW: UISwitch!
    @IBOutlet var commentSW: UISwitch!
    @IBOutlet var mentionSW: UISwitch!
    @IBOutlet var followSW: UISwitch!
    
    private let userVM = UserVM()
    private let disposeBag = DisposeBag()
    private let alarmSettingVariants:[String] = [
        AlarmSetting.Variant.PUSH,
        AlarmSetting.Variant.LIKES,
        AlarmSetting.Variant.SCRAP,
        AlarmSetting.Variant.COMMENT,
        AlarmSetting.Variant.MENTION,
        AlarmSetting.Variant.FOLLOW
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    private func setupViews(){
        title = "알림 설정"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDefaultValue()
    }
    
    private func setupDefaultValue(){
        guard let currentUser = UserDefaultHelper.shared.getCurrentUser() else { return }
        /// Setup Event Notification
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if(settings.authorizationStatus == .authorized){
                    self.eventSW.isOn = true
                    return
                }
                self.eventSW.isOn = false
            }
        }
        
        /// Setup Other Notification from Server
        likeSW.isOn = currentUser.alarmLike
        scrapSW.isOn = currentUser.alarmScrap
        commentSW.isOn = currentUser.alarmComment
        mentionSW.isOn = currentUser.alarmMention
        followSW.isOn = currentUser.alarmFollow
    }
    
    private func observeViewModel(){
        userVM.successMsg.bind{ (errorMsg) in
            self.userVM.getUserDetail()
        }.disposed(by: disposeBag)
        
        userVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    private func showEventSettingPopup(){
        let alert = UIAlertController(title: "알림 설정", message: "기기의 알림 설정이 꺼져있어요 휴대폰 설정 > 알림 > 갬성캠퍼에서 설정을 변경해주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정 변경하기", style: .default, handler: {(action: UIAlertAction) in
            guard let url = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) else { return }
            UIApplication.shared.open(url)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchAction(_ sender: UISwitch){
        if sender.tag == 0 {
            eventSW.isOn = false
            showEventSettingPopup()
            return
        }
        userVM.updateAlarmSetting(type: alarmSettingVariants[sender.tag], isAllowance: sender.isOn)
    }
}
