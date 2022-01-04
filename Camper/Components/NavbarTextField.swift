//
//  NavbarTextField.swift
//  Camper
//
//  Created by Filbert Hartawan on 20/12/21.
//

import Foundation
import UIKit

protocol NavbarSearchViewDelegate{
    func textFieldDidChange(text: String)
}

class NavbarTextField: UITextField{
    private let clearBtnSize: CGFloat = 21
    var customDelegate:NavbarSearchViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        addTarget(superview?.parentContainerViewController(), action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.height))
        leftViewMode = .always
        
        let clearBtnV = UIView(frame: CGRect(x: 0, y: 0, width: clearBtnSize, height: frame.height))
        let clearBtn = UIButton(frame: CGRect(x: 0, y: frame.height/2 - clearBtnSize/2, width: clearBtnSize, height: clearBtnSize))
        clearBtn.setImage(UIImage(named: "clear-icon"), for: .normal)
        clearBtn.addTarget(self, action: #selector(clearTextField(_:)), for: .touchUpInside)
        clearBtnV.addSubview(clearBtn)
        rightView = clearBtnV
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField){
        rightViewMode = text!.isEmpty ? .never : .always
        customDelegate?.textFieldDidChange(text: text!)
    }
    
    @objc private func clearTextField(_ sender: UIButton){
        text!.removeAll()
        customDelegate?.textFieldDidChange(text: text!)
    }
}
