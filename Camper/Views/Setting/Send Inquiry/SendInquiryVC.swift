//
//  SendInquiryVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import UIKit
import RxSwift
import SVProgressHUD

class SendInquiryVC: UIViewController {
    
    @IBOutlet var topicL: UILabel!
    
    @IBOutlet var topicVContainer: CamperViewButton!
    
    @IBOutlet var topicDropdownVContainer: UIView!
    
    @IBOutlet var coantentTextV: UITextView!
    
    private let inquiryVM = InquiryVM()
    private let disposeBag = DisposeBag()
    private var selectedTopicId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    private func setupViews(){
        title = "의견 보내기"
        hideKeyboardWhenTappedAround()
        setupNavigationBar(isActive: false)
        
        topicVContainer.delegate = self
        topicVContainer.rounded(corners: [.allCorners], radius: 4)
        topicDropdownVContainer.rounded(corners: [.bottomLeft, .bottomRight], radius: 4)
        
        coantentTextV.delegate = self
    }
    
    private func observeViewModel(){
        inquiryVM.successMsg.bind{ (successMsg) in
            SVProgressHUD.dismiss()
            self.showSuccessPopup()
        }.disposed(by: disposeBag)
        
        inquiryVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    private func setupNavigationBar(isActive: Bool){
        let doneBtn = UIButton()
        doneBtn.setTitle("보내기", for: .normal)
        doneBtn.setTitleColor(.placeholderText, for: .normal)
        if isActive {
            doneBtn.setTitleColor(UIColor(named: "primary-text"), for: .normal)
            doneBtn.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBtn)
    }
    
    private func toggleDropdown(){
        topicDropdownVContainer.isHidden = !topicDropdownVContainer.isHidden
        if topicDropdownVContainer.isHidden {
            topicVContainer.rounded(corners: [.allCorners], radius: 4)
            return
        }
        topicVContainer.rounded(corners: [.topLeft, .topRight], radius: 4)
    }
    
    private func showSuccessPopup(){
        let alert = UIAlertController(title: "보내기 완료!", message: "소중한 의견 전달해주셔서 감사합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {(action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func sendAction(){
        guard let topicId = selectedTopicId else { return }
        dismissKeyboard()
        SVProgressHUD.show()
        inquiryVM.sendInquiry(topicId: topicId, content: coantentTextV.text)
    }
    
    @IBAction func dropdownAction(_ sender: UIButton) {
        topicL.text = sender.titleLabel?.text
        topicL.textColor = .black
        selectedTopicId = sender.tag
        toggleDropdown()
    }
}

extension SendInquiryVC: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {        
        toggleDropdown()
    }
}

extension SendInquiryVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
    }
    
    func textViewDidChange(_ textView: UITextView) {
        setupNavigationBar(isActive: !textView.text.isEmpty)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "갬성캠퍼에 요청해주시고 싶은 내용을 작성해 주세요."
            textView.textColor = .separator
            setupNavigationBar(isActive: false)
        }
    }
}
