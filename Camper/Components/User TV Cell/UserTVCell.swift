//
//  UserTVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 20/12/21.
//

import UIKit

protocol UserCellDelegate {
    func didRemoveUser(user: User)
}

class UserTVCell: UITableViewCell {

    @IBOutlet var nicknameL: UILabel!
    @IBOutlet var introL: UILabel!
    @IBOutlet var deleteBtn: UIButton!
    
    var user: User?
    var delegate: UserCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with user: User, isRemoveable: Bool){
        self.user = user
        nicknameL.text = user.nickname
        introL.text = user.intro ?? "-"
        deleteBtn.isHidden = !isRemoveable
    }
    
    @IBAction func closeAction(_ sender: Any) {
        delegate?.didRemoveUser(user: user!)
    }
}
