//
//  FeedsVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit
import SideMenu
import RxSwift

class FeedsVC: UIViewController {

    @IBOutlet var backpackBtn: CamperViewButton!
    @IBOutlet var filterBtn: CamperViewButton!
    
    @IBOutlet var profileIV: UIImageView!
    
    private var leftSideMenu: SideMenuNavigationController?
    private var rightSideMenu: SideMenuNavigationController?
    private let categoryVM = CategoryVM()
    private let generalVM = GeneralVM()
    private let disposeBag = DisposeBag()
    private var categories:[Category] = []
    private var currentPopup: Popup?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
        observeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFilterMenu()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SideMenuManager.default.rightMenuNavigationController = nil
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupViews(){
        backpackBtn.layer.cornerRadius = 2
        backpackBtn.layer.borderWidth = 1
        backpackBtn.layer.borderColor = UIColor.white.cgColor
        
        profileIV.layer.cornerRadius = 2
                
        setupSideMenu()
        setupFilterMenu()
    }
    
    private func setupSideMenu(){
        let sideMenuVC = SideMenuVC()
        sideMenuVC.delegate = self
        leftSideMenu = SideMenuNavigationController(rootViewController: sideMenuVC)
        leftSideMenu?.presentationStyle = .menuSlideIn
        leftSideMenu?.presentationStyle.backgroundColor = .black
        leftSideMenu?.presentationStyle.presentingEndAlpha = 0.5
        SideMenuManager.default.leftMenuNavigationController = leftSideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
    }
    
    private func setupFilterMenu(){
        let filterMenuVC = FilterMenuVC()
        filterMenuVC.categories = categories
        rightSideMenu = SideMenuNavigationController(rootViewController: filterMenuVC)
        rightSideMenu?.presentationStyle = .menuSlideIn
        rightSideMenu?.presentationStyle.backgroundColor = .black
        rightSideMenu?.presentationStyle.presentingEndAlpha = 0.5
        SideMenuManager.default.rightMenuNavigationController = rightSideMenu
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        /// Setup Filter Icon Button
        filterBtn.delegate = self
    }
    
    private func setupData(){
        categoryVM.getAllCategory()
    }
    
    private func observeViewModel(){
        generalVM.popups.bind{ (popups) in
            let openedPopups = UserDefaultHelper.shared.getOpenedPopups()
            for popup in popups {
                /// Show popup  when current popup not opened
                if !openedPopups.contains(where: { $0 == popup.id }){
                    self.currentPopup = popup
                    self.showPopupVC(popup: popup)
                    break
                }
            }
        }.disposed(by: disposeBag)
        
        categoryVM.categories.bind{ (categories) in
            self.categories = categories
            self.generalVM.getAllPopup()
            self.setupFilterMenu()
        }.disposed(by: disposeBag)
        
        categoryVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
        
        generalVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    private func showPopupVC(popup: Popup){
        let popupVC = PopupAdsVC()
        popupVC.currentPopup = popup
        popupVC.modalPresentationStyle = .fullScreen
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func showSideMenu(_ sender: Any) {
        present(leftSideMenu!, animated: true, completion: nil)
    }
    
    @IBAction func showFilterMenu(_ sender: Any) {
        present(rightSideMenu!, animated: true, completion: nil)
    }
}

extension FeedsVC: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {
        present(rightSideMenu!, animated: true, completion: nil)
    }
}

extension FeedsVC: SideMenuDelegate{
    func loginAction() {
        let loginMethodVC = UINavigationController(rootViewController: LoginMethodVC())
        loginMethodVC.modalPresentationStyle = .fullScreen
        present(loginMethodVC, animated: true, completion: nil)
    }
    
    func addFeedsAction() {
        let photoSelectVC = UINavigationController(rootViewController: PhotoSelectVC())
        photoSelectVC.modalPresentationStyle = .fullScreen
        present(photoSelectVC, animated: true, completion: nil)
    }
    
    func myPageAction() {
        let myPageVC = MyPageVC()
        myPageVC.currentUser = UserDefaultHelper.shared.getCurrentUser()
        navigationController?.pushViewController(myPageVC, animated: true)
    }
}
