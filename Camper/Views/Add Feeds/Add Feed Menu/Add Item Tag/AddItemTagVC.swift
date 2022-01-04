//
//  AddItemTagVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 27/12/21.
//

import UIKit
import Photos

class AddItemTagVC: UIViewController {
    
    @IBOutlet var containerV: UIView!
    @IBOutlet var imageIV: UIImageView!
    
    var feed: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        PHImageManager.default().requestImage(for: feed!, targetSize: CGSize(width: view.frame.width, height: view.frame.height), contentMode: .aspectFill, options: nil) { image, info in
            self.imageIV.image = image
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageAction(_:)))
        containerV.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func tapImageAction(_ sender: UITapGestureRecognizer){
        let selectItemTagVC = SelectItemTagVC()
        let navVC = UINavigationController(rootViewController: selectItemTagVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
        
        print(sender.location(in: sender.view))
    }
}
