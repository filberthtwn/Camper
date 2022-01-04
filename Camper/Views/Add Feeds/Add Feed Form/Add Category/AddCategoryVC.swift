//
//  AddCategoryVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 20/12/21.
//

import UIKit
import PanModal
import RxSwift

class AddCategoryVC: UIViewController {
    var height: CGFloat = 0

    @IBOutlet var categoryCV: UICollectionView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var doneBtn: UIButton!
    
    private var isLoaded = false
    private let disposeBag = DisposeBag()
    private var categoryVM = CategoryVM()
    private var categories: [Category] = []
    
    var delegate: AddFeedFormDelegate?
    var selectedCategories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
        observeViewModel()
    }
    
    private func setupViews(){
        doneBtn.isEnabled = false
        categoryCV.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        categoryCV.register(UINib(nibName: "AddCategoryCVCell", bundle: nil), forCellWithReuseIdentifier: "AddCategoryCell")
    }
    
    private func setupData(){
        categoryVM.getAllCategory()
    }
    
    private func observeViewModel(){
        categoryVM.categories.bind{ (categories) in
            self.doneBtn.isEnabled = true
            self.doneBtn.setTitleColor(UIColor(named: "primary-text"), for: .normal)
            self.loadingIndicator.isHidden = true
            self.categories = categories
            self.categoryCV.reloadData()
        }.disposed(by: disposeBag)
        
        categoryVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        delegate?.didCategorySelected(categories: selectedCategories.sorted(by: { $0.name < $1.name } ))
        dismiss(animated: true, completion: nil)
    }
}

extension AddCategoryVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(height)
    }
    
    var longFormHeight: PanModalHeight{
        return .contentHeight(height)
    }
    
    var showDragIndicator: Bool{
        return false
    }
}

extension AddCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categoryCV.frame.width / 2 - 28, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        if selectedCategories.contains(where: { $0.id == category.id }){
            selectedCategories.removeAll(where: { $0.id == category.id })
        }else{
            if selectedCategories.count < 3 {
                selectedCategories.append(category)
            }
        }
        categoryCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.item]
        let isSelected = selectedCategories.contains(where: {$0.id == category.id} )
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCategoryCell", for: indexPath) as! AddCategoryCVCell
        cell.configure(category: category, isSelected: isSelected)
        return cell
    }
}
