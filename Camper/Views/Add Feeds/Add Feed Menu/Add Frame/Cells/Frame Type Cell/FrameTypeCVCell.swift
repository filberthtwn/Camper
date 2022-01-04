//
//  FrameTypeCVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/12/21.
//

import UIKit

class FrameTypeCVCell: UICollectionViewCell {
    
    @IBOutlet var noneFrameBtn: CamperViewButton!
    @IBOutlet var fullFrameBtn: CamperViewButton!
    @IBOutlet var fourFiveFrameBtn: CamperViewButton!
    @IBOutlet var oneOneFrameBtn: CamperViewButton!
    
    @IBOutlet var noneFrameIV: UIImageView!
    @IBOutlet var fullFrameIV: UIImageView!
    @IBOutlet var fourFiveFrameIV: UIImageView!
    @IBOutlet var oneOneFrameIV: UIImageView!
    
    @IBOutlet var noneFrameL: UILabel!
    @IBOutlet var fullFrameL: UILabel!
    @IBOutlet var fourFiveFrameL: UILabel!
    @IBOutlet var oneOneFrameL: UILabel!
    
    var delegate: SelectFrameDelegate?
    var selectedFrameType: Int = FrameType.NONE {
        didSet {
            setupFrameButton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup(){
        noneFrameBtn.delegate = self
        fullFrameBtn.delegate = self
        fourFiveFrameBtn.delegate = self
        oneOneFrameBtn.delegate = self
    }
    
    private func setupFrameButton(){
        noneFrameIV.tintColor = .black
        fullFrameIV.tintColor = .black
        fourFiveFrameIV.tintColor = .black
        oneOneFrameIV.tintColor = .black
        
        noneFrameL.textColor = .black
        fullFrameL.textColor = .black
        fourFiveFrameL.textColor = .black
        oneOneFrameL.textColor = .black
                
        switch selectedFrameType {
        case FrameType.NONE:
            noneFrameIV.tintColor = UIColor(named: "primary-text")
            noneFrameL.textColor = UIColor(named: "primary-text")
        case FrameType.FULL:
            fullFrameIV.tintColor = UIColor(named: "primary-text")
            fullFrameL.textColor = UIColor(named: "primary-text")
        case FrameType.FOURFIVE:
            fourFiveFrameIV.tintColor = UIColor(named: "primary-text")
            fourFiveFrameL.textColor = UIColor(named: "primary-text")
        case FrameType.SQUARE:
            oneOneFrameIV.tintColor = UIColor(named: "primary-text")
            oneOneFrameL.textColor = UIColor(named: "primary-text")
        default:
            break
        }
    }
}

extension FrameTypeCVCell: CamperButtonDelegate{
    func didButtonClicked(_ sender: CamperViewButton) {
        switch sender {
        case noneFrameBtn:
            selectedFrameType = FrameType.NONE
            break
        case fullFrameBtn:
            selectedFrameType = FrameType.FULL
            break
        case fourFiveFrameBtn:
            selectedFrameType = FrameType.FOURFIVE
            break
        case oneOneFrameBtn:
            selectedFrameType = FrameType.SQUARE
            break
        default:
            break
        }
        delegate?.didSelectFrameType(frameType: selectedFrameType)
        setupFrameButton()
    }
}
