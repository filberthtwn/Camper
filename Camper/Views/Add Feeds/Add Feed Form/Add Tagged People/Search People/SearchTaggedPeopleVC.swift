//
//  SearchTaggedPeopleVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 03/01/22.
//

import UIKit
import RxSwift

protocol SearchTaggedPeopleDelegate {
    func didSelectFollower(follower: User)
}

class SearchTaggedPeopleVC: UIViewController {

    @IBOutlet var taggedPeopleTV: UITableView!
    
    private var searchTF: NavbarTextField?
    private var page = 0
    private var limit = 15
    private var totalPage = 0
    private var searchQuery = ""
    private var isLoaded = false
    private let userVM = UserVM()
    private var followers: [User] = []
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    var delegate: SearchTaggedPeopleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
        observeViewModel()
    }
    
    private func setupViews(){
        setupNavbar()
        
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged )
        taggedPeopleTV.addSubview(refreshControl)
        taggedPeopleTV.register(UINib(nibName: "UserShimmerTVCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
        taggedPeopleTV.register(UINib(nibName: "UserTVCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    private func setupNavbar(){
        navigationItem.showDismissIcon()
        
        searchTF = NavbarTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        searchTF!.customDelegate = self
        searchTF!.placeholder = "아이디를 검색하세요"
        navigationItem.titleView = searchTF
    }
    
    private func setupData(){
        userVM.getAllFollowingFollowers(state: .FOLLOWERS, limit: limit, page: page, searchQuery: searchQuery)
    }
    
    private func observeViewModel(){
        userVM.followingsFollowers.bind{ (followerResp) in
            self.isLoaded = true
            if self.page == 0 {
                self.followers.removeAll()
            }
            self.followers.append(contentsOf: followerResp.users)
            self.taggedPeopleTV.reloadData()
        }.disposed(by: disposeBag)
        
        userVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    @objc private func refresh(){
        searchTF!.text?.removeAll()
        searchQuery.removeAll()
        reloadItems()
    }
    
    @objc private func reloadItems(){
        page = 0
        totalPage = 0
        isLoaded = false
        followers.removeAll()
        taggedPeopleTV.reloadData()
        setupData()
    }
}

extension SearchTaggedPeopleVC: NavbarSearchViewDelegate{
    func textFieldDidChange(text: String) {
        searchQuery = text
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadItems), object: nil)
        perform(#selector(reloadItems), with: nil, afterDelay: 0.5)
    }
}

extension SearchTaggedPeopleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isLoaded{
            return 10
        }
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectFollower(follower: followers[indexPath.item])
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isLoaded{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShimmerCell", for: indexPath)
            return cell
        }
        let user = followers[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTVCell
        cell.configure(with: user, isRemoveable: false)
        return cell
    }
}
