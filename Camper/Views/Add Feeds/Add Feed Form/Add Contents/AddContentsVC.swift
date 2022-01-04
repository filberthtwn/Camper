//
//  AddContentsVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 20/12/21.
//

import UIKit

protocol AddContentDelegate{
    func didContentUpdated(content: String)
}

class AddContentsVC: UIViewController {

    @IBOutlet var contentTextV: UITextView!
    
    var delegate: AddContentDelegate?
    var content: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavbar()
    }
    
    private func setupViews(){
        contentTextV.becomeFirstResponder()
        contentTextV.textContainerInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        
        contentTextV.text = content
    }
    
    private func setupNavbar(){
        title = "문구 입력"
        navigationItem.showDismissIcon()
        navigationItem.showRightButton(target: self, title: "확인", do: #selector(doneAction))
    }
    
    @objc private func doneAction(){
        delegate?.didContentUpdated(content: contentTextV.text!)
        dismiss(animated: true, completion: nil)
    }
}

extension AddContentsVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 500 {
            textView.text!.removeLast()
        }
    }
}
