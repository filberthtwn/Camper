//
//  CamperTextField.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import Foundation
import UIKit

class CamperTextField: UITextField{
    var inset: CGFloat = 16

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: frame.height))
        leftViewMode = .always
        
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: frame.height))
        rightViewMode = .always
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: inset, dy: inset)
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: inset, dy: inset)
//    }
}
