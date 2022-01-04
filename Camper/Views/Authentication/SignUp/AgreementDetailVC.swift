//
//  AgreementDetailVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit
import RxSwift

class AgreementDetailVC: UIViewController {

    @IBOutlet var contentScrollV: UIScrollView!
    
    @IBOutlet var contentL: UILabel!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var type = SystemString.Variant.SERVICE_USAGE_AGREEMENT
    
    private let generalVM = GeneralVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
        observeViewModel()
    }
    
    private func setupViews(){
        contentScrollV.isHidden = true
    }
    
    private func setupData(){
        generalVM.getSystemString(type: type)
    }
    
    private func observeViewModel(){
        generalVM.content.bind{ (content) in
            self.loadingIndicator.isHidden = true
            self.contentScrollV.isHidden = false
            self.contentL.text = content
        }.disposed(by: disposeBag)
        
        generalVM.errorMsg.bind{ (errorMsg) in
            self.loadingIndicator.isHidden = true
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
}
