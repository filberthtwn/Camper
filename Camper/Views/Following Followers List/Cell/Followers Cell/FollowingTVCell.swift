//
//  FollowersTVCell.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import UIKit

class FollowingTVCell: UITableViewCell {
    
    @IBOutlet var userBtn: CamperViewButton!
    
    @IBOutlet var profilePictureIV: RoundedImageView!
    
    @IBOutlet var nicknameL: UILabel!
    @IBOutlet var introL: UILabel!
    
    @IBOutlet var followBtn: CamperButton!
    
    private var user: User?
    
    var delegate: FollowersFollowingDelegate?
    
    var isUnfollow: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews(){
        userBtn.delegate = self
        followBtn.setAsOutline(borderColor: UIColor(named: "primary-text")!)
    }
    
    func configure(with user: User){
        self.user = user
        nicknameL.text = user.nickname
        introL.text = user.intro
        
        followBtn.backgroundColor = .clear
        followBtn.setTitleColor(UIColor(named: "primary-text")!, for: .normal)
        followBtn.setTitle("팔로잉", for: .normal)
        
        if isUnfollow {
            followBtn.backgroundColor = UIColor(named: "primary-text")
            followBtn.setTitleColor(.white, for: .normal)
            followBtn.setTitle("팔로우", for: .normal)
        }
        
        if let currentUser = UserDefaultHelper.shared.getCurrentUser(){
            followBtn.isHidden = (user.id == currentUser.id)
        }
        
        if let isFollowing = user.isFollowing {
            isFollowing ? setAsFollowing() : setAsFollow()
        }
        
        if let imageUrl = URL(string: Network.ASSET_URL + (user.profilePicture ?? "")){
            profilePictureIV.af.setImage(withURL: imageUrl)
        }
    }
    
    private func setAsFollow(){
        followBtn.backgroundColor = UIColor(named: "primary-text")
        followBtn.setTitleColor(.white, for: .normal)
        followBtn.setTitle("팔로우", for: .normal)
    }
    
    private func setAsFollowing(){
        followBtn.backgroundColor = .clear
        followBtn.setTitleColor(UIColor(named: "primary-text"), for: .normal)
        followBtn.setTitle("팔로잉", for: .normal)
    }
    
    @IBAction func followAction(_ sender: Any) {
        guard let user = self.user, let isFollowing = user.isFollowing else { return }
        isFollowing ? delegate?.didUnfollowUser(user: user) : delegate?.didFollowUser(user: user)
    }
}

extension FollowingTVCell: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {
        delegate?.didUserSelected(user: user!)
    }
}
