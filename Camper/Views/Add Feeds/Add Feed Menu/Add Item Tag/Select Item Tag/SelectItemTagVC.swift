//
//  SelectItemTagVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 27/12/21.
//

import UIKit
import RxSwift

class SelectItemTagVC: UIViewController {

    @IBOutlet var itemCV: UICollectionView!
    
    @IBOutlet var emptyStateV: UIView!
    
    private var searchTF: NavbarTextField?
    private let refreshControl = UIRefreshControl()
    private var items: [Item] = []
    private let itemVM = ItemVM()
    private let disposeBag = DisposeBag()
    private var isLoaded = false
    private var isPagingLoaded = false
    private var searchQuery = ""
    private var page = 0
    private var totalPage = 0
    private var limit = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        obvserveViewModel()
        setupNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    private func setupViews(){
        hideKeyboardWhenTappedAround()
        emptyStateV.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged )
        itemCV.addSubview(refreshControl)
        itemCV.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        itemCV.register(UINib(nibName: "ShimmerItemTagCVCell", bundle: nil), forCellWithReuseIdentifier: "ShimmerItemCell")
        itemCV.register(UINib(nibName: "ItemTagCVCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        itemCV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FooterCell")
        itemCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCell")
    }
    
    private func setupData(){
        itemVM.getAllItems(limit: limit, page: page, search: searchQuery)
    }
    
    private func obvserveViewModel(){
        itemVM.itemResp.bind{ (itemResp) in
            self.isLoaded = true
            self.isPagingLoaded = false
            self.totalPage = itemResp.totalPages
            self.refreshControl.endRefreshing()
            
            if self.page == 0 {
                self.items.removeAll()
            }
            
            self.items.append(contentsOf: itemResp.items)
            self.itemCV.reloadData()
            
            if self.items.count == 0 {
                self.emptyStateV.isHidden = false
            }
        }.disposed(by: disposeBag)
        
        itemVM.errorMsg.bind{ (errMsg) in
            DialogHelper.shared.showError(errorMsg: errMsg, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    private func setupNavbar(){
        navigationItem.showDismissIcon()
        
        searchTF = NavbarTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        searchTF!.delegate = self
        searchTF!.customDelegate = self
        searchTF!.placeholder = "아이템의 제품명, 브랜드를 검색하세요"
        navigationItem.titleView = searchTF
    }
    
    @objc private func reloadItems(){
        emptyStateV.isHidden = true
        isLoaded = false
        items.removeAll()
        totalPage = 0
        page = 0
        itemCV.reloadData()
        setupData()
    }
    
    @objc private func refresh(){
        searchTF!.text?.removeAll()
        searchQuery.removeAll()
        reloadItems()
    }
    
    @IBAction func registerItemAction(_ sender: Any) {
        let registerItemTagVC = RegisterItemTagVC()
        navigationController?.pushViewController(registerItemTagVC, animated: true)
    }
}

extension SelectItemTagVC: NavbarSearchViewDelegate, UITextFieldDelegate{
    func textFieldDidChange(text: String) {
        searchQuery = text
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadItems), object: nil)
        perform(#selector(reloadItems), with: nil, afterDelay: 0.5)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
}

extension SelectItemTagVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            if !isLoaded { return }
            if page < (totalPage - 1) {
                isPagingLoaded = true
                page += 1
                itemCV.reloadData()
                setupData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if !isPagingLoaded {
            return .zero
        }
        return CGSize(width: itemCV.frame.width, height: CGFloat(35))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCell", for: indexPath)
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: itemCV.frame.width, height: CGFloat(35))
        spinner.startAnimating()
        view.addSubview(spinner)
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemCV.frame.width / 3 - 12, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isLoaded {
            return 15
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !isLoaded {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShimmerItemCell", for: indexPath)
            return cell
        }
        
        let item = items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemTagCVCell
        cell.configure(with: item)
        return cell
    }
}
