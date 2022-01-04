//
//  FAQVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 23/11/21.
//

import UIKit
import RxSwift

class FAQItem {
    var faq: FAQ?
    var isOpened = false
}

class FAQVC: UIViewController {

    @IBOutlet var faqTV: UITableView!
    
    private let faqVM = FaqVM()
    private var isLoaded = false
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var faqItems: [FAQItem] = []
    
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
        title = "FAQ"
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged )
        faqTV.addSubview(refreshControl)
        faqTV.register(UINib(nibName: "TextShimmerTVCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
        faqTV.register(UINib(nibName: "FAQTitleTVCell", bundle: nil), forCellReuseIdentifier: "FAQTitleCell")
        faqTV.register(UINib(nibName: "FAQContentTVCell", bundle: nil), forCellReuseIdentifier: "FAQContentCell")
    }
    
    private func setupData(){
        faqVM.getAllFAQ(limit: limit, page: page)
    }
    
    private func observeViewModel(){
        faqVM.faqResp.bind{ (faqResp) in
            for faq in faqResp.faqs {
                let faqItem = FAQItem()
                faqItem.faq = faq
                self.faqItems.append(faqItem)
            }
            self.isLoaded = true
            self.totalPage = faqResp.totalPages
            self.faqTV.tableFooterView = nil
            self.faqTV.reloadData()
            self.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)
        
        faqVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    @objc private func refresh(){
        isLoaded = false
        page = 0
        faqItems.removeAll()
        faqTV.reloadData()
        setupData()
    }
}

extension FAQVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isLoaded { return }
        if page < (totalPage - 1) {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: faqTV.frame.width, height: CGFloat(35))
            faqTV.tableFooterView = spinner
            spinner.startAnimating()
            
            page += 1
            setupData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !isLoaded {
            return 1
        }
        return faqItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isLoaded {
            return 10
        }
        
        if faqItems[section].isOpened {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShimmerCell", for: indexPath) as! TextShimmerTVCell
            return cell
        }
        
        let faq = faqItems[indexPath.section].faq!
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTitleCell", for: indexPath) as! FAQTitleTVCell
            cell.configure(faq: faq, index: indexPath.section + 1)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQContentCell", for: indexPath) as! FAQContentTVCell
        cell.configure(faq: faq)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoaded {
            faqItems[indexPath.section].isOpened = !faqItems[indexPath.section].isOpened
            faqTV.reloadSections([indexPath.section], with: .none)
        }
    }
}
