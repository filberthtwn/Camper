//
//  RecoverIdVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 15/11/21.
//

import UIKit

class RecoverIdVC: UIViewController {

    @IBOutlet var strokeV: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        title = "아이디 찾기"
    }
    
    @IBAction func authenticateAction(_ sender: Any) {
        let showIDVC = ShowIDVC()
        navigationController?.pushViewController(showIDVC, animated: true)
    }
}
