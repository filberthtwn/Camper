//
//  MyPageVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 22/11/21.
//

import UIKit
import AlamofireImage
import RxSwift

enum MyPageState {
    case MY
    case OTHER
}

class MyPageVC: UIViewController {
    
    @IBOutlet var mainScrollV: UIScrollView!
    
    @IBOutlet var bioShimmerV: ShimmerView!
    
    @IBOutlet var myFollowersBtn: CamperViewButton!
    @IBOutlet var myFollowingBtn: CamperViewButton!
    @IBOutlet var myFeedsBtn: CamperViewButton!
    @IBOutlet var myScrappedFeedsBtn: CamperViewButton!
    @IBOutlet var myBackpackFeedsBtn: CamperViewButton!
    @IBOutlet var loginBtn: CamperViewButton!
    @IBOutlet var signupBtn: CamperViewButton!
    
    @IBOutlet var userInfoV: UIStackView!
    
    @IBOutlet var bioV: UIView!
    @IBOutlet var bioShimmerContentV: UIView!
    @IBOutlet var emptyStateV: UIView!
    @IBOutlet var authStateV: UIView!
    @IBOutlet var indicatorV: UIView!
    @IBOutlet var followV: UIView!
    
    @IBOutlet var indicatorLeadingC: NSLayoutConstraint!
    
    @IBOutlet var followersCountL: UILabel!
    @IBOutlet var followingCountL: UILabel!
    @IBOutlet var mainCV: UICollectionView!
    
    @IBOutlet var introL: UILabel!
    
    @IBOutlet var followBtn: CamperButton!
    
    @IBOutlet var profilePictureIV: RoundedImageView!
    
    @IBOutlet var countLs: [UILabel]!
    @IBOutlet var icons: [UIImageView]!
    
    private let userVM = UserVM()
    private let disposeBag = DisposeBag()
    private let viewControllers = ["MyFeedsVC", "ScrappedFeedsVC","MyBackpackFeedsVC"]
    
    var state: MyPageState = .MY
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentUser != nil {
            setupData()
            bioShimmerV.contentView = bioShimmerContentV
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bioV.isHidden =  currentUser != nil
        bioShimmerV.isHidden = currentUser == nil
        /// Logged Out State
        if currentUser == nil {
            followV.isHidden = true
            setupDefaultValue()
            return
        }
        
        title = currentUser?.nickname
        
        authStateV.isHidden = true
        emptyStateV.isHidden = true
    }
    
    private func setupViews(){
        myFollowersBtn.delegate = self
        myFollowingBtn.delegate = self
        myFeedsBtn.delegate = self
        myScrappedFeedsBtn.delegate = self
        myBackpackFeedsBtn.delegate = self
        loginBtn.delegate = self
        signupBtn.delegate = self
        
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(named: "primary-text")!.cgColor
        
        mainCV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            
        setupNavigationBar()
    }
    
    private func setupData(){
        switch state {
            case .MY:
                userVM.getUserDetail()
            case .OTHER:
                userVM.getOtherUserDetail(nickname: currentUser!.nickname)
        }
    }
    
    private func observeViewModel(){
        userVM.user.bind{ (user) in
            self.bioShimmerV.isHidden = true
            self.bioV.isHidden = false
            self.currentUser = user
            self.setupDefaultValue()
        }.disposed(by: disposeBag)
        
        userVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    private func setupDefaultValue(){        
        guard let currentUser = self.currentUser else {
            if state == .MY {
                userInfoV.isHidden = true
                authStateV.isHidden = false
                profilePictureIV.image = UIImage(named: "profile-placeholder-image")
                for countL in countLs {
                    countL.text = "-"
                }
                emptyStateV.isHidden = false
                mainCV.isHidden = true
            }
            return
        }
        
        title = currentUser.nickname
        followersCountL.text = "팔로우 \(currentUser.followersCount.shorted)"
        followingCountL.text = "팔로잉 \(currentUser.followingCount.shorted)"
        userInfoV.isHidden = false
        authStateV.isHidden = true
        emptyStateV.isHidden = true
        mainCV.isHidden = false
        introL.text = (currentUser.intro != nil && currentUser.intro != "") ? currentUser.intro : "-"
        
        /// Toggle Follow View
        if let loggedInUser = UserDefaultHelper.shared.getCurrentUser(){
            followV.isHidden = currentUser.id == loggedInUser.id
        }
        
        if let isFollowing = currentUser.isFollowing {
            isFollowing ? setAsFollowing() : setAsFollow()
        }
        
        if let imageUrl = URL(string: Network.ASSET_URL + (currentUser.profilePicture ?? "")){
            profilePictureIV.af.setImage(withURL: imageUrl, placeholderImage: UIImage())
        }
    }
    
    private func setupNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "bars-icon"), style: .plain, target: self, action: #selector(openActionSetting))
    }
    
    private func setupTabButton(selectedIndex: Int){
        for (index, icon) in icons.enumerated() {
            icon.tintColor = .black
            countLs[index].textColor = .black
            
            switch index {
            case 0:
                icon.image = UIImage(named: "camp-outline-icon")
                if selectedIndex == index{
                    icon.image = UIImage(named: "camp-icon")
                }
            case 1:
                icon.image = UIImage(named: "scrap-outline-icon")
                if selectedIndex == index{
                    icon.image = UIImage(named: "scrap-icon")
                }
            case 2:
                icon.image = UIImage(named: "backpack-outline-icon")
                if selectedIndex == index{
                    icon.image = UIImage(named: "backpack-icon")
                }
            default:
                break
            }
        }
        
        icons[selectedIndex].tintColor = UIColor(named: "primary-text")
        countLs[selectedIndex].textColor = UIColor(named: "primary-text")
    }
    
    private func setAsFollow(){
        UIView.performWithoutAnimation {
            self.followBtn.backgroundColor = UIColor(named: "primary-text")
            self.followBtn.setTitleColor(.white, for: .normal)
            self.followBtn.setTitle("팔로우", for: .normal)
            self.view.layoutIfNeeded()
        }
    }
    
    private func setAsFollowing(){
        UIView.performWithoutAnimation {
            self.followBtn.backgroundColor = .clear
            self.followBtn.setTitleColor(UIColor(named: "primary-text"), for: .normal)
            self.followBtn.setTitle("팔로잉", for: .normal)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func openActionSetting(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "설정", style: .default , handler: { (UIAlertAction) in
            let settingVC = SettingVC()
            self.navigationController?.pushViewController(settingVC, animated: true)
        }))
        
        if UserDefaultHelper.shared.getCurrentUser() != nil {
            alert.addAction(UIAlertAction(title: "보관함", style: .default , handler: { (UIAlertAction) in
                let savedFeedsVC = SavedFeedsVC()
                self.navigationController?.pushViewController(savedFeedsVC, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "공유", style: .default , handler: { (UIAlertAction) in
                guard let currentUser = UserDefaultHelper.shared.getCurrentUser() else { return }
                let text = "\(Network.BASE_URL)/user/\(currentUser.nickname)"
                let textToShare = [text]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func followAction(_ sender: Any) {
        if let isFollowing = currentUser!.isFollowing{
            isFollowing ? userVM.unfollowUser(userId: currentUser!.id) : userVM.followUser(userId: currentUser!.id)
            currentUser!.isFollowing = !isFollowing
            !isFollowing ? setAsFollowing() : setAsFollow()
        }
    }
}

extension MyPageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: mainCV.frame.width, height: mainCV.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        var viewController: UIViewController = MyFeedsVC()
        
        switch self.viewControllers[indexPath.row]{
        case "MyFeedsVC":
            viewController = MyFeedsVC()
        case "ScrappedFeedsVC":
            viewController = ScrappedFeedsVC()
        case "MyBackpackFeedsVC":
            viewController = MyBackpackFeedsVC()
        default:
            break
        }
        
        self.addChild(viewController)
        viewController.view.frame = CGRect(x: 0,y: 0, width: self.mainCV.frame.width, height: self.mainCV.frame.height)
        cell.addSubview(viewController.view)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        indicatorLeadingC.constant = indicatorV.frame.width * (scrollView.contentOffset.x/mainCV.frame.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let selectedIndex = Int(scrollView.contentOffset.x/mainCV.frame.width)
        setupTabButton(selectedIndex: selectedIndex)
    }
}

extension MyPageVC: CamperButtonDelegate{
    func didButtonClicked(_ sender: CamperViewButton) {
        switch sender {
        case myFollowersBtn:
            let followingFollowersVC = FollowingFollowersListVC()
            followingFollowersVC.state = .FOLLOWERS
            followingFollowersVC.currentUser = currentUser
            followingFollowersVC.isCurrentUser = (state == .MY)
            navigationController?.pushViewController(followingFollowersVC, animated: true)
        case myFollowingBtn:
            let followingFollowersVC = FollowingFollowersListVC()
            followingFollowersVC.state = .FOLLOWING
            followingFollowersVC.currentUser = currentUser
            followingFollowersVC.isCurrentUser = (state == .MY)
            navigationController?.pushViewController(followingFollowersVC, animated: true)
        case myFeedsBtn:
            mainCV.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
            setupTabButton(selectedIndex: 0)
        case myScrappedFeedsBtn:
            mainCV.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
            setupTabButton(selectedIndex: 1)
        case myBackpackFeedsBtn:
            mainCV.scrollToItem(at: IndexPath(row: 2, section: 0), at: .left, animated: true)
            setupTabButton(selectedIndex: 2)
        case loginBtn, signupBtn:
            let loginMethodVC = UINavigationController(rootViewController: LoginMethodVC())
            loginMethodVC.modalPresentationStyle = .fullScreen
            present(loginMethodVC, animated: true, completion: nil)
        default:
            break
        }
    }
}
