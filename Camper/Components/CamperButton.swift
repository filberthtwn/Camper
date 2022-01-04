//
//  CamperButton.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import Foundation
import UIKit

class CamperButton: UIButton{
    
    var activityIndicator: UIActivityIndicatorView?
    var title: String?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.cornerRadius = 8
        title = titleLabel?.text
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func showLoading(){
        setTitle("", for: .normal)
        activityIndicator = createActivityIndicator()
        showSpinning()
    }
    
    func hideLoading(){
        setTitle(title, for: .normal)
        activityIndicator?.removeFromSuperview()
    }
    
    func disable(){
        isUserInteractionEnabled = false
        backgroundColor = UIColor.lightGray
    }
    
    func enable(bgColor: UIColor){
        isUserInteractionEnabled = true
        backgroundColor = bgColor
    }
    
    func setAsOutline(borderColor: UIColor){
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
    }
    
    func setAsFilled(bgColor: UIColor){
        layer.backgroundColor = bgColor.cgColor
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        
        return activityIndicator
    }
    
    private func showSpinning() {
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.center = CGPoint(x: bounds.width/2, y:  bounds.height/2)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}
