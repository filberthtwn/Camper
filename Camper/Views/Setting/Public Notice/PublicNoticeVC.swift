//
//  PublicNoticeVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 23/11/21.
//

import UIKit
import RxCocoa
import RxSwift

class PublicNoticeItem {
    var publicNotice: PublicNotice?
    var isOpened:Bool = false
}

class PublicNoticeVC: UIViewController {
    
    @IBOutlet var publicNoticeTV: UITableView!
    
    private var isLoaded = false
    private let publiceNoticeVM = PublicNoticeVM()
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var publicNoticeItems: [PublicNoticeItem] = []
    
    private var limit = 15
    private var page = 0
    private var totalPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
        observeViewModel()
    }
    
    private func setupViews(){
        title = "공지사항"
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged )
        publicNoticeTV.addSubview(refreshControl)
        publicNoticeTV.register(UINib(nibName: "TextShimmerTVCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
        publicNoticeTV.register(UINib(nibName: "PublicNoticeTitleTVCell", bundle: nil), forCellReuseIdentifier: "PublicNoticeTitleCell")
        publicNoticeTV.register(UINib(nibName: "PublicNoticeContentTVCell", bundle: nil), forCellReuseIdentifier: "PublicNoticeContentCell")
    }
    
    private func setupData(){
        publiceNoticeVM.getAllPublicNotice(limit: limit, page: page)
    }
    
    private func observeViewModel(){
        publiceNoticeVM.publicNoticeResp.bind{ (publicNoticeResp) in
            for publicNotice in publicNoticeResp.publicNotices {
                let publicNoticeItem = PublicNoticeItem()
                publicNoticeItem.publicNotice = publicNotice
                self.publicNoticeItems.append(publicNoticeItem)
            }
            self.isLoaded = true
            self.totalPage = publicNoticeResp.totalPages
            self.publicNoticeTV.tableFooterView = nil
            self.publicNoticeTV.reloadData()
            self.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)
        
        publiceNoticeVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    @objc private func refresh(){
        isLoaded = false
        page = 0
        publicNoticeItems.removeAll()
        publicNoticeTV.reloadData()
        setupData()
    }
}

extension PublicNoticeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isLoaded { return }
        if page < (totalPage - 1) {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: publicNoticeTV.frame.width, height: CGFloat(35))
            publicNoticeTV.tableFooterView = spinner
            spinner.startAnimating()
            
            page += 1
            setupData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !isLoaded {
            return 1
        }
        return publicNoticeItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isLoaded {
            return 10
        }
        
        if publicNoticeItems[section].isOpened {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShimmerCell", for: indexPath) as! TextShimmerTVCell
            return cell
        }
        
        let publicNotice = publicNoticeItems[indexPath.section].publicNotice!
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicNoticeTitleCell", for: indexPath) as! PublicNoticeTitleTVCell
            cell.configure(with: publicNotice)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublicNoticeContentCell", for: indexPath) as! PublicNoticeContentTVCell
        cell.configure(with: publicNotice)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoaded {
            publicNoticeItems[indexPath.section].isOpened = !publicNoticeItems[indexPath.section].isOpened
            publicNoticeTV.reloadSections([indexPath.section], with: .none)
        }
    }
}
