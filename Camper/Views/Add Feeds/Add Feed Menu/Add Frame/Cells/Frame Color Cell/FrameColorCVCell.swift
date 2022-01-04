//
//  FrameColorCVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/12/21.
//

import UIKit

class FrameColorCVCell: UICollectionViewCell {
    
    @IBOutlet var whiteBgBtn: CamperViewButton!
    @IBOutlet var orangeBgBtn: CamperViewButton!
    @IBOutlet var mintBgBtn: CamperViewButton!
    @IBOutlet var grayBgBtn: CamperViewButton!
    
    @IBOutlet var whiteBgV: UIView!
    @IBOutlet var orangeBgV: UIView!
    @IBOutlet var mintBgV: UIView!
    @IBOutlet var grayBgV: UIView!
    
    @IBOutlet var whiteBgL: UILabel!
    @IBOutlet var orangeBgL: UILabel!
    @IBOutlet var mintBgL: UILabel!
    @IBOutlet var grayBgL: UILabel!
    
    var delegate: SelectFrameDelegate?
    var selectedColor: UIColor = Colors.FRAME_WHITE {
        didSet{
            setupColorButton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup(){
        whiteBgBtn.delegate = self
        whiteBgV.layer.borderWidth = 2
        
        orangeBgBtn.delegate = self
        orangeBgV.layer.borderWidth = 2
        
        mintBgBtn.delegate = self
        mintBgV.layer.borderWidth = 2
        
        grayBgBtn.delegate = self
        grayBgV.layer.borderWidth = 2
        
        setupColorButton()
    }
    
    private func setupColorButton(){
        whiteBgV.layer.borderColor = selectedColor == Colors.FRAME_WHITE ? UIColor(named: "primary-text")!.cgColor : UIColor.black.cgColor
        whiteBgL.textColor = selectedColor == Colors.FRAME_WHITE ? UIColor(named: "primary-text")! : UIColor.black
        
        orangeBgV.layer.borderColor = selectedColor == Colors.FRAME_ORANGE ? UIColor(named: "primary-text")!.cgColor : UIColor.clear.cgColor
        orangeBgL.textColor = selectedColor == Colors.FRAME_ORANGE ? UIColor(named: "primary-text")! : UIColor.black
        
        mintBgV.layer.borderColor = selectedColor == Colors.FRAME_MINT ? UIColor(named: "primary-text")!.cgColor : UIColor.clear.cgColor
        mintBgL.textColor = selectedColor == Colors.FRAME_MINT ? UIColor(named: "primary-text")! : UIColor.black

        grayBgV.layer.borderColor = selectedColor == Colors.FRAME_GRAY ? UIColor(named: "primary-text")!.cgColor : UIColor.clear.cgColor
        grayBgL.textColor = selectedColor == Colors.FRAME_GRAY ? UIColor(named: "primary-text")! : UIColor.black
    }
}

extension FrameColorCVCell: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {
        switch sender {
        case whiteBgBtn:
            selectedColor = Colors.FRAME_WHITE
            break
        case orangeBgBtn:
            selectedColor = Colors.FRAME_ORANGE
            break
        case mintBgBtn:
            selectedColor = Colors.FRAME_MINT
            break
        case grayBgBtn:
            selectedColor = Colors.FRAME_GRAY
            break
        default:
            break
        }
        setupColorButton()
        delegate?.didSelectColor(color: selectedColor)
    }
}
