//
//  CamperButton.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import Foundation
import UIKit

protocol CamperButtonDelegate{
    func didButtonClicked(_ sender: CamperViewButton)
}

class CamperViewButton: UIView{
    var delegate: CamperButtonDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func rounded(){
        layer.cornerRadius = 8
    }
    
    func roundedFull(){
        layer.cornerRadius = frame.height/2
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        layer.opacity = 0.5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        layer.opacity = 1
        
        delegate?.didButtonClicked(self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        layer.opacity = 1
    }
}
