//
//  AddCommentVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 27/12/21.
//

import UIKit

class AddCommentVC: UIViewController {
    
    @IBOutlet var commentTF: UITextField!
    
    @IBOutlet var feedV: UIView!
    @IBOutlet var modalContainerV: UIView!
    
    @IBOutlet var justifyLeftBtn: CamperViewButton!
    @IBOutlet var justifyCenterBtn: CamperViewButton!
    @IBOutlet var justifyRightBtn: CamperViewButton!
    
    @IBOutlet var containerVBottomC: NSLayoutConstraint!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commentTF.becomeFirstResponder()
    }
    
    private func setupViews(){
        justifyLeftBtn.delegate = self
        justifyCenterBtn.delegate = self
        justifyRightBtn.delegate = self
        
        commentTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        commentTF.isHidden = true
        feedV.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        modalContainerV.rounded(corners: [.topLeft, .topRight], radius: 20)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        if sender.text!.count > 15 {
            sender.text!.removeLast()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            var topInset: CGFloat = 0
            var bottomInset: CGFloat = 0
            if #available(iOS 13.0, *) {
                let window = UIApplication.shared.windows.first
                topInset = window?.safeAreaInsets.top ?? 0
                bottomInset = window?.safeAreaInsets.bottom ?? 0
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                /// Animate Modal Container View
                self.containerVBottomC.constant = keyboardHeight - bottomInset
                self.view.layoutIfNeeded()
                
                /// Animate Feed View
                let offsetY = topInset
                let scaleFactor = self.feedV.frame.width/self.feedV.frame.height
                let height = self.feedV.frame.height - (self.modalContainerV.frame.height + keyboardHeight + topInset + 32)
                let newWidth = height * scaleFactor
                self.feedV.frame = CGRect(x: self.view.frame.width/2 - newWidth/2, y: offsetY, width: newWidth, height: height)
            } completion: { _ in
                self.commentTF.isHidden = false
                self.commentTF.frame = CGRect(x: 8, y: (self.feedV.frame.height - 35) - 24, width: self.feedV.frame.width - 16, height: 35)
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    
    private func dismissVC(){
        dismissKeyboard()
        commentTF.isHidden = true
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.feedV.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        } completion: { isDone in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismissVC()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        dismissVC()
    }
}

extension AddCommentVC: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {
        switch sender {
        case justifyLeftBtn:
            commentTF.textAlignment = .left
        case justifyCenterBtn:
            commentTF.textAlignment = .center
        case justifyRightBtn:
            commentTF.textAlignment = .right
        default: break
        }
    }
}
