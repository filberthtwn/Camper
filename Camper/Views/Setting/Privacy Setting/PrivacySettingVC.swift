//
//  PrivacySettingVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 23/11/21.
//

import UIKit

protocol PrivacySettingDelegate{
    func didUpdatePrivacySetting(variant: String, code: Int)
    func didUpdateFollowerCheck(followerCheck: Bool)
}

class PrivacySettingVC: UIViewController {

    @IBOutlet var feedPrivacyBtn: CamperViewButton!
    @IBOutlet var scrapePrivacyBtn: CamperViewButton!
    @IBOutlet var taggedItemBtn: CamperViewButton!
    @IBOutlet var followersBtn: CamperViewButton!
    
    @IBOutlet var feedsL: UILabel!
    @IBOutlet var scrapL: UILabel!
    @IBOutlet var backpackL: UILabel!
    @IBOutlet var followerCheckL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDefaultValue()
    }
    
    private func setupViews(){
        title = "공개 범위"
        
        feedPrivacyBtn.delegate = self
        scrapePrivacyBtn.delegate = self
        taggedItemBtn.delegate = self
        followersBtn.delegate = self
    }
    
    private func setupDefaultValue(){
        guard let currentUser = UserDefaultHelper.shared.getCurrentUser() else { return }
        
        feedsL.text = getSetting(code: currentUser.settingFeeds)
        scrapL.text = getSetting(code: currentUser.settingScraps)
        backpackL.text = getSetting(code: currentUser.settingTaggedItems)
        followerCheckL.text = currentUser.followerCheck ? "검토함" : "검토안함"
    }
    
    private func getSetting(code: Int) -> String{
        switch code {
        case 0:
            return "전체공개"
        case 1:
            return "팔로워만"
        case 2:
            return "비공개"
        default:
            return "-"
        }
    }
}

extension PrivacySettingVC: CamperButtonDelegate{
    func didButtonClicked(_ sender: CamperViewButton) {
        var viewController: UIViewController?
        
        switch sender {
        case feedPrivacyBtn:
            viewController = PrivacySettingDetailVC()
            (viewController as! PrivacySettingDetailVC).delegate = self
            (viewController as! PrivacySettingDetailVC).variant = PrivacySetting.Variant.FEED
            viewController!.title = "게시물 공개범위"
            break
        case scrapePrivacyBtn:
            viewController = PrivacySettingDetailVC()
            (viewController as! PrivacySettingDetailVC).delegate = self
            (viewController as! PrivacySettingDetailVC).variant = PrivacySetting.Variant.SCRAP
            viewController!.title = "스크랩 공개범위"
            break
        case taggedItemBtn:
            viewController = PrivacySettingDetailVC()
            (viewController as! PrivacySettingDetailVC).delegate = self
            (viewController as! PrivacySettingDetailVC).variant = PrivacySetting.Variant.ITEM
            viewController!.title = "태그한 아이템 공개범위"
            break
        case followersBtn:
            viewController = FollowerCheckVC()
            (viewController as! FollowerCheckVC).delegate = self
            break
        default:
            break
        }
        
        navigationController?.pushViewController(viewController!, animated: true)
    }
}

extension PrivacySettingVC: PrivacySettingDelegate{
    func didUpdatePrivacySetting(variant: String, code: Int) {
        switch variant {
        case PrivacySetting.Variant.FEED:
            feedsL.text = getSetting(code: code)
        case PrivacySetting.Variant.SCRAP:
            scrapL.text = getSetting(code: code)
        case PrivacySetting.Variant.ITEM:
            backpackL.text = getSetting(code: code)
        default:
            break
        }
    }
    
    func didUpdateFollowerCheck(followerCheck: Bool){
        followerCheckL.text = followerCheck ? "검토함" : "검토안함"
    }
}
