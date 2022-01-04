//
//  RegisterItemTagVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 27/12/21.
//

import UIKit
import RxSwift
import SVProgressHUD

class RegisterItemTagVC: UIViewController {

    @IBOutlet var brandNameTF: UITextField!
    @IBOutlet var itemNameTF: UITextField!
    @IBOutlet var priceTF: UITextField!
    @IBOutlet var linkTF: UITextField!
    
    private let itemVM = ItemVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    private func setupViews(){
        title = "아이템 직접 등록"
        hideKeyboardWhenTappedAround()
        navigationController?.navigationItem.showDismissIcon()
        navigationItem.showRightButton(target: self, title: "완료", do: #selector(doneAction))
    }
    
    private func observeViewModel(){
        itemVM.successMsg.bind{ (successMsg) in
            DialogHelper.shared.showSuccess(message: successMsg) {
                self.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: disposeBag)
        
        itemVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    private func validate() -> Bool{
        if brandNameTF.text!.isEmpty{
            return false
        }
        
        if itemNameTF.text!.isEmpty{
            return false
        }
        
        if priceTF.text!.isEmpty{
            return false
        }
        
        if linkTF.text!.isEmpty{
            return false
        }
        
        return true
    }
    
    @objc private func doneAction(){
        if !validate() {
            DialogHelper.shared.showError(errorMsg: Message.FILL_THE_BLANKS, completion: nil)
            return
        }
        SVProgressHUD.show()
        itemVM.createNewItem(name: itemNameTF.text!, brandName: brandNameTF.text!, price: priceTF.text!, link: linkTF.text!)
    }
}
