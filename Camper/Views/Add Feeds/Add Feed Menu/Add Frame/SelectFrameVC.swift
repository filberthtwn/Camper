//
//  SelectFrameVCViewController.swift
//  Camper
//
//  Created by Filbert Hartawan on 20/12/21.
//

import UIKit
import Photos

struct FrameType {
    static let NONE = 0
    static let FULL = 1
    static let FOURFIVE = 2
    static let SQUARE = 3
}

struct FrameMenu {
    static let FRAME_TYPE = 0
    static let POSITION = 1
    static let COLOR = 2
}

protocol SelectFrameDelegate {
    func didSelectFrameType(frameType: Int)
    func didSelectColor(color: UIColor)
}

class SelectFrameVC: UIViewController {
    
    @IBOutlet var feedV: UIView!
    @IBOutlet var modalContainerV: UIView!
    
    @IBOutlet var frameMenuCV: UICollectionView!
    
    @IBOutlet var menuTitle: UILabel!
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var doneBtn: UIButton!
    
    private var selectedMenu: Int = FrameMenu.FRAME_TYPE
    private let fullFrameInset: CGFloat = 24
    private let menuTitles = ["프레임 선택", "위치 선택", "배경색 선택"]
    
    var delegate: AddFeedMenuDelegate?
    var selectedFrameType: Int = FrameType.NONE
    var selectedColor: UIColor = .clear
    var feedFrameRect: CGRect?
    var feedIV: UIImageView?
    var lastFrame: CGRect?
    var feed: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let lastFrame = lastFrame {
            feedV.frame = lastFrame
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimated()
    }
    
    private func setupViews(){
        backBtn.isHidden = true
        
        modalContainerV.rounded(corners: [.topLeft, .topRight], radius: 20)
        
        frameMenuCV.register(UINib(nibName: "FrameTypeCVCell", bundle: nil), forCellWithReuseIdentifier: "FrameTypeCell")
        frameMenuCV.register(UINib(nibName: "FramePositionCVCell", bundle: nil), forCellWithReuseIdentifier: "FramePosCell")
        frameMenuCV.register(UINib(nibName: "FrameColorCVCell", bundle: nil), forCellWithReuseIdentifier: "FrameColorCell")
        
        setupFeedView()
        didSelectFrameType(frameType: selectedFrameType)
    }
    
    private func setupFeedView(){
        feedIV = UIImageView(frame: self.lastFrame!)
        feedIV!.contentMode = .scaleAspectFit
        view.addSubview(feedIV!)
        
        PHImageManager.default().requestImage(for: feed!, targetSize: CGSize(width: view.frame.width, height: view.frame.height), contentMode: .aspectFill, options: nil) { image, info in
            self.feedIV!.image = image
            self.view.layoutIfNeeded()
        }
    }
    
    private func startAnimated(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            let scaleFactor = self.feedV.frame.width/self.feedV.frame.height
            let height = self.feedV.frame.height - 300
            let newWidth = height * scaleFactor
            
            let offsetX = self.view.frame.width/2 - newWidth/2
            let offsetY = self.view.safeAreaInsets.bottom + 24
            
            self.feedV.frame = CGRect(x: offsetX, y: offsetY, width: newWidth, height: height)
            self.feedIV!.frame = CGRect(x: offsetX, y: offsetY, width: newWidth, height: height)
            self.view.layoutIfNeeded()
        }
    }
    
    private func dismissVC(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.feedV.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.feedIV!.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        } completion: { isDone in
            self.delegate?.didUpdateFrame(frameType: self.selectedFrameType, color: self.selectedColor)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func moveMenuToColor(){
        doneBtn.setImage(UIImage(named: "check-icon"), for: .normal)
        selectedMenu = FrameMenu.COLOR
        frameMenuCV.scrollToItem(at: IndexPath(item: FrameMenu.COLOR, section: 0), at: .left, animated: true)
        menuTitle.text = menuTitles[selectedMenu]
    }
    
    private func setupFrameColor(){
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        doneBtn.setImage(UIImage(named: "chevron-right-icon"), for: .normal)

        switch selectedMenu {
        case FrameMenu.POSITION:
            selectedMenu = FrameMenu.FRAME_TYPE
            break
        case FrameMenu.COLOR:
            selectedMenu = FrameMenu.POSITION
            if selectedFrameType == FrameType.FULL {
                selectedMenu = FrameMenu.FRAME_TYPE
            }
            break
        default:
            break
        }
        
        if selectedMenu == FrameMenu.FRAME_TYPE {
            backBtn.isHidden = true
        }
        
        frameMenuCV.scrollToItem(at: IndexPath(item: selectedMenu, section: 0), at: .right, animated: true)
        menuTitle.text = menuTitles[selectedMenu]
    }
    
    @IBAction func doneAction(_ sender: Any) {
        /// Do when current menu is FRAME TYPE
        if selectedMenu == FrameMenu.FRAME_TYPE {
            /// Do when  Frame Type NONE
            if selectedFrameType == FrameType.NONE {
                dismissVC()
                return
            }
            
            /// Show Back Button when Frame is not NONE
            backBtn.isHidden = false
            
            /// Do when  Frame Type FULL
            if selectedFrameType == FrameType.FULL {
                moveMenuToColor()
                return
            }
            
            /// Do when Frame is not Type NONE && Frame Type FULL
            menuTitle.text = "위치 선택"
            selectedMenu = FrameMenu.POSITION
            frameMenuCV.scrollToItem(at: IndexPath(item: FrameMenu.POSITION, section: 0), at: .left, animated: true)
            menuTitle.text = menuTitles[selectedMenu]
            return
        }
        
        /// Do when current menu is POSITION
        if selectedMenu == FrameMenu.POSITION {
            moveMenuToColor()
            return
        }
        
        /// Do when current menu is POSITION
        if selectedMenu == FrameMenu.COLOR {
            selectedMenu = FrameMenu.FRAME_TYPE
            dismissVC()
        }
    }
}

extension SelectFrameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frameMenuCV.frame.width, height: frameMenuCV.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameTypeCell", for: indexPath) as! FrameTypeCVCell
            cell.delegate = self
            cell.selectedFrameType = selectedFrameType
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FramePosCell", for: indexPath) as! FramePositionCVCell
//            cell.delegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameColorCell", for: indexPath) as! FrameColorCVCell
            cell.delegate = self
            cell.selectedColor = selectedColor
            return cell
        }
    }
}

extension SelectFrameVC: SelectFrameDelegate {
    func didSelectFrameType(frameType: Int) {
        
        selectedFrameType = frameType
        
        doneBtn.setImage(UIImage(named: "check-icon"), for: .normal)
        if frameType != FrameType.NONE{
            feedV.backgroundColor = selectedColor
            
            /// Do When Selected Color not Selected Yet or Frame Type is NONE
            if selectedColor == .clear{
                selectedColor = .white
                feedV.backgroundColor = selectedColor
                frameMenuCV.reloadData()
            }
            doneBtn.setImage(UIImage(named: "chevron-right-icon"), for: .normal)
        }
        
        switch frameType {
        case FrameType.NONE:
            selectedColor = .clear
            feedV.backgroundColor = .clear
            if feedFrameRect == nil {
                feedIV!.frame = CGRect(x: feedV.frame.origin.x, y: feedV.frame.origin.y, width: feedV.frame.width, height: feedV.frame.height)
            }
            break
        case FrameType.FULL:
            if feedFrameRect == nil {
                feedIV!.frame = CGRect(x: feedV.frame.origin.x + fullFrameInset/2, y: feedV.frame.origin.y + fullFrameInset/2, width: feedV.frame.width - fullFrameInset, height: feedV.frame.height - fullFrameInset)
            }
            break
        case FrameType.FOURFIVE:
            
            break
        case FrameType.SQUARE:
            
            break
        default:
            break
        }
    }
    
    func didSelectColor(color: UIColor){
        selectedColor = color
        feedV.backgroundColor = selectedColor
    }
}
