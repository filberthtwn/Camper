//
//  MascotDialog.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import Foundation
import UIKit

class MascotDialog: UIView{
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup(){
        let lineWidth: CGFloat = 1
        
        /// Draw Dialog Tail
        let tailBezierPath = UIBezierPath()
        let tailMinY: CGFloat = 8
        tailBezierPath.move(to: CGPoint(x: bounds.minX + 16 + lineWidth, y: bounds.minY + tailMinY))
        tailBezierPath.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + (tailMinY + 8)))
        tailBezierPath.addLine(to: CGPoint(x: bounds.minX + 16 + lineWidth, y: bounds.minY + (tailMinY + 16)))
                
        let mainBodyShape = CAShapeLayer()
        mainBodyShape.lineWidth = lineWidth
        let rect = CGRect(x: 16, y: 0, width: bounds.width - 16, height: bounds.height)
        mainBodyShape.path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 10.0, height: 10.0)).cgPath
        mainBodyShape.strokeColor = UIColor.black.cgColor
        mainBodyShape.fillColor = UIColor.white.cgColor
        
        let tailShape = CAShapeLayer()
        tailShape.lineWidth = lineWidth
        tailShape.path = tailBezierPath.cgPath
        tailShape.strokeColor = UIColor.black.cgColor
        tailShape.fillColor = UIColor.white.cgColor
        
        layer.insertSublayer(mainBodyShape, at: 0)
        layer.insertSublayer(tailShape, at: 1)
    }
}
