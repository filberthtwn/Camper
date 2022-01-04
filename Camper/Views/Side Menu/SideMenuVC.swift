//
//  MainVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 22/11/21.
//

import UIKit

protocol SideMenuDelegate{
    func loginAction()
    func addFeedsAction()
    func myPageAction()
}

class SideMenuVC: UIViewController {
    
    @IBOutlet var profilePictureIV: RoundedImageView!
    
    @IBOutlet var nicknameL: UILabel!
    
    @IBOutlet var currentUserBtn: CamperViewButton!
    @IBOutlet var popularFeedsBtn: CamperViewButton!
    @IBOutlet var homeFeedsBtn: CamperViewButton!
    @IBOutlet var newFeedBtn: CamperViewButton!
    @IBOutlet var searchBtn: CamperViewButton!
    @IBOutlet var myPageBtn: CamperViewButton!
    @IBOutlet var alarmBtn: CamperViewButton!
    
    var delegate: SideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDefaultValue()
    }
    
    private func setupViews(){
        navigationController?.isNavigationBarHidden = true
        
        setupDefaultValue()
        
        currentUserBtn.delegate = self
        popularFeedsBtn.delegate = self
        homeFeedsBtn.delegate = self
        newFeedBtn.delegate = self
        searchBtn.delegate = self
        myPageBtn.delegate = self
        alarmBtn.delegate = self
    }
    
    private func setupDefaultValue(){
        guard let currentUser = UserDefaultHelper.shared.getCurrentUser() else { return }
        nicknameL.text = currentUser.nickname
        currentUserBtn.isUserInteractionEnabled = false
        
        if let imageUrlStr = currentUser.profilePicture, let imageUrl = URL(string: Network.ASSET_URL + imageUrlStr){
            profilePictureIV.af.setImage(withURL: imageUrl, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.25))
        }
    }
}

extension SideMenuVC: CamperButtonDelegate{
    func didButtonClicked(_ sender: CamperViewButton) {
        switch sender {
        case currentUserBtn:
            dismiss(animated: true, completion: nil)
            delegate?.loginAction()
            break
        case popularFeedsBtn:
            break
        case homeFeedsBtn:
            break
        case newFeedBtn:
            dismiss(animated: true, completion: nil)
            delegate?.addFeedsAction()
            break
        case searchBtn:
            break
        case myPageBtn:
            dismiss(animated: true, completion: nil)
            delegate?.myPageAction()
            break
        case alarmBtn:
            break
        default:
            break
        }
    }
}
