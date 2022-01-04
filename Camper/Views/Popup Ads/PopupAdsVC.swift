//
//  PopupAdsVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 22/11/21.
//

import UIKit
import RxSwift

class PopupAdsVC: UIViewController {

    @IBOutlet var popupImageIV: UIImageView!
    
    var currentPopup: Popup?

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        if let imageUrlStr = currentPopup!.image, let imageUrl = URL(string: Network.ASSET_URL + imageUrlStr){
            self.popupImageIV.af.setImage(withURL: imageUrl)
            return
        }
    }
    
    @IBAction func dontShowAgainAction(_ sender: Any) {
        guard let currentPopup = self.currentPopup else { return }
        UserDefaultHelper.shared.setupOpenedPopup(popupId: currentPopup.id)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
