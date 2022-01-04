//
//  UIView+Ext.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import Foundation
import UIKit

extension UIView {
    func roundedWithStroke(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.lineWidth = 1
        mask.strokeColor = UIColor.black.cgColor
        mask.fillColor = UIColor.white.cgColor
        
        for sublayer in layer.sublayers! {
            if sublayer.isKind(of: CAShapeLayer.self){
                sublayer.removeFromSuperlayer()
            }
        }
        
        layer.insertSublayer(mask, at: 0)
    }
    
    func rounded(corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
