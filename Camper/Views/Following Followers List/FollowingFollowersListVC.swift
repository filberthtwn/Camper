//
//  FollowListVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import UIKit
import RxSwift

enum FollowingFollowersState {
    case FOLLOWING
    case FOLLOWERS
}

protocol FollowersFollowingDelegate {
    func didUserSelected(user: User)
    func didUnfollowUser(user: User)
    func didFollowUser(user: User)
    func didDeleteFollowing(user: User)
}

class FollowingFollowersListVC: UIViewController {
    
    @IBOutlet var userListTV: UITableView!
    
    @IBOutlet var indicatorLeadingC: NSLayoutConstraint!
    
    @IBOutlet var searchTF: CamperTextField!
    
    @IBOutlet var emptyStateL: UILabel!
    
    @IBOutlet var followersBtn: UIButton!
    @IBOutlet var followingBtn: UIButton!
    
    var state: FollowingFollowersState = .FOLLOWERS
    var isCurrentUser = true
    var currentUser: User?
    
    private var unfollowedUsers:[User] = []
    private let refreshControl = UIRefreshControl()
    private var userVM = UserVM()
    private var disposeBag = DisposeBag()
    private var users: [User] = []
    private var isLoaded = false
    private var limit = 15
    private var page = 0
    private var totalPage = 0
    private var totalFollowing = 0
    private var searchQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    private func setupViews(){
        if isCurrentUser {
            guard let currentUser = UserDefaultHelper.shared.getCurrentUser() else { return }
            self.currentUser = currentUser
        }
        
        title = currentUser!.nickname
        
        setupDefaultValue()
        hideKeyboardWhenTappedAround()
        setupSearchTF()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged )
        userListTV.addSubview(refreshControl)
        
        userListTV.register(UINib(nibName: "UserShimmerTVCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
        userListTV.register(UINib(nibName: "FollowingTVCell", bundle: nil), forCellReuseIdentifier: "FollowingCell")
        userListTV.register(UINib(nibName: "FollowerTVCell", bundle: nil), forCellReuseIdentifier: "FollowersCell")
        
        if state == .FOLLOWING {
            indicatorLeadingC.constant = view.frame.width / 2
        }
    }
    
    private func setupDefaultValue(){
        guard let currentUser = self.currentUser else { return }
        totalFollowing = currentUser.followingCount
        UIView.performWithoutAnimation {
            followersBtn.setTitle("\(currentUser.followersCount.shorted) 팔로워", for: .normal)
            followingBtn.setTitle("\(currentUser.followingCount.shorted) 팔로잉", for: .normal)
        }
    }
    
    private func setupData(){
        if isCurrentUser {
            userVM.getAllFollowingFollowers(state: state, limit: limit, page: page, searchQuery: searchQuery)
        }else{
            userVM.getAllOtherFollowingFollowers(state: state, nickname: currentUser!.nickname, limit: limit, page: page, searchQuery: searchQuery)
        }
    }
    
    private func observeViewModel(){
        userVM.followingsFollowers.bind{ (followingsFollowers) in
            self.isLoaded = true
            self.totalPage = followingsFollowers.totalPages
            self.users.append(contentsOf: followingsFollowers.users)
            
            self.emptyStateL.isHidden = true
            if followingsFollowers.users.count == 0 {
                self.emptyStateL.isHidden = false
            }
            
            if self.searchQuery.isEmpty{
                switch self.state {
                    case .FOLLOWERS:
                        UIView.performWithoutAnimation {
                            self.followersBtn.setTitle("\(followingsFollowers.totalItems) 팔로워", for: .normal)
                            self.view.layoutIfNeeded()
                        }
                    case .FOLLOWING:
                        UIView.performWithoutAnimation {
                            self.followingBtn.setTitle("\(followingsFollowers.totalItems) 팔로잉", for: .normal)
                            self.view.layoutIfNeeded()
                        }
                        self.totalFollowing = followingsFollowers.totalItems
                }
            }
            
            self.userListTV.tableFooterView = nil
            self.userListTV.reloadData()
            self.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)
        
        userVM.isDeleteSuccess.bind{ (isDeleteSuccess) in
            self.refresh()
        }.disposed(by: disposeBag)
        
        userVM.errorMsg.bind{ (errorMsg) in
            if self.isLoaded {
                self.refresh()
                self.setupDefaultValue()
            }
            self.refreshControl.endRefreshing()
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    @objc private func refresh(){
        isLoaded = false
        totalPage = 0
        page = 0
        users.removeAll()
        emptyStateL.isHidden = true
        unfollowedUsers.removeAll()
        userListTV.reloadData()
        
        userVM = UserVM()
        disposeBag = DisposeBag()
        
        setupData()
        observeViewModel()
    }
    
    private func setupSearchTF(){
        let searchIconWidth = 14
        let view = UIView(frame: CGRect(x: 0, y: 0, width: searchIconWidth + 16 + 8, height: 14))
        let iconIV = UIImageView(frame: CGRect(x: 16, y: 0, width: 14, height: 14))
        iconIV.image = UIImage(named: "search-icon")
        view.addSubview(iconIV)
        searchTF.leftView = view
        searchTF.leftViewMode = .always
        
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        searchQuery = searchTF.text!
        refresh()
    }
    
    @IBAction func showFollowersAction(_ sender: Any) {
        searchQuery = ""
        searchTF.text = ""
        emptyStateL.isHidden = true
        indicatorLeadingC.constant = 0
        state = .FOLLOWERS
        refresh()
    }
    
    @IBAction func showFollowingAction(_ sender: Any) {
        searchQuery = ""
        searchTF.text = ""
        emptyStateL.isHidden = true
        indicatorLeadingC.constant = view.frame.width / 2
        state = .FOLLOWING
        refresh()
    }
}

extension FollowingFollowersListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isLoaded { return }
        if page < (totalPage - 1) {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: userListTV.frame.width, height: CGFloat(35))
            userListTV.tableFooterView = spinner
            spinner.startAnimating()
            
            page += 1
            setupData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isLoaded{
            return 10
        }
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !isLoaded{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShimmerCell", for: indexPath) as! UserShimmerTVCell
            return cell
        }
        
        let user = users[indexPath.row]
        switch state {
            case .FOLLOWERS:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell", for: indexPath) as! FollowerTVCell
                    cell.delegate = self
                    cell.isUnfollow = unfollowedUsers.contains(where: { $0.id == user.id})
                    cell.configure(with: user, isCurrentUser: isCurrentUser)
                return cell
            case .FOLLOWING:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingCell", for: indexPath) as! FollowingTVCell
                cell.delegate = self
                cell.isUnfollow = unfollowedUsers.contains(where: { $0.id == user.id})
                cell.configure(with: user)
                return cell
        }
    }
}

extension FollowingFollowersListVC: FollowersFollowingDelegate{
    func didUserSelected(user: User) {
        let myPageVC = MyPageVC()
        myPageVC.state = .OTHER
        myPageVC.currentUser = user
        navigationController?.pushViewController(myPageVC, animated: true)
    }
    
    func didUnfollowUser(user: User){
        userVM.unfollowUser(userId: user.id)
        totalFollowing-=1
        UIView.performWithoutAnimation {
            followingBtn.setTitle("\(totalFollowing.shorted) 팔로워", for: .normal)
            view.layoutIfNeeded()
        }
        
        if let user = users.first(where: { $0.id == user.id }){
            user.isFollowing = false
        }
        
        userListTV.reloadData()
    }
    
    func didFollowUser(user: User) {
        userVM.followUser(userId: user.id)
        unfollowedUsers.removeAll(where: { $0.id == user.id })
        totalFollowing+=1
        UIView.performWithoutAnimation {
            followingBtn.setTitle("\(totalFollowing.shorted) 팔로워", for: .normal)
            view.layoutIfNeeded()
        }
        
        if let user = users.first(where: { $0.id == user.id }){
            user.isFollowing = true
        }
        
        userListTV.reloadData()
    }
    
    func didDeleteFollowing(user: User){
        let alert = UIAlertController(title: "\(user.nickname) 님이 팔로우 하지 못하도록 삭제 할까요?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { action in
            self.userVM.deleteFollower(userId: user.id)
            UIView.performWithoutAnimation {
                self.followersBtn.setTitle("\((self.currentUser!.followersCount - 1).shorted) 팔로워", for: .normal)
            }
            self.users.removeAll(where: { $0.id == user.id })
            self.userListTV.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
}

