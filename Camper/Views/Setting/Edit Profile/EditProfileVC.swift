//
//  EditProfileVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 22/11/21.
//

import UIKit
import RxSwift
import AlamofireImage
import SVProgressHUD

class EditProfileVC: UIViewController {

    @IBOutlet var profilePictureBtn: CamperViewButton!
    
    @IBOutlet var profilePictureIV: RoundedImageView!
    
    @IBOutlet var nicknameTF: UITextField!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var introTF: UITextField!
    
    private var message:String?
    private var selectedImage: UIImage?
    private let userVM = UserVM()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
    }
    
    private func setupViews(){
        title = "프로필 편집"
        hideKeyboardWhenTappedAround()
        setupNavigationBar()
        setupDefaultValue()
        
        profilePictureBtn.delegate = self
        profilePictureIV.layer.cornerRadius = 20
    }
    
    private func setupDefaultValue(){
        guard let currentUser = UserDefaultHelper.shared.getCurrentUser() else { return }
        nicknameTF.text = currentUser.nickname
        nameTF.text = currentUser.name
        introTF.text = currentUser.intro
        
        if let imageUrlStr = currentUser.profilePicture, let imageUrl = URL(string: Network.ASSET_URL + imageUrlStr){
            profilePictureIV.af.setImage(withURL: imageUrl, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.25))
        }
    }
    
    private func observeViewModel(){
        userVM.successMsg.bind{ (successMsg) in
            self.message = successMsg
            self.userVM.getUserDetail()
        }.disposed(by: disposeBag)
        
        userVM.user.bind{ (user) in
            /// Alamofire remove all images from cache
            UIImageView.af.sharedImageDownloader.imageCache?.removeAllImages()
            DialogHelper.shared.showSuccess(message: self.message, completion: {})
        }.disposed(by: disposeBag)
        
        userVM.errorMsg.bind{ (errorMsg) in
            DialogHelper.shared.showError(errorMsg: errorMsg)
        }.disposed(by: disposeBag)
    }
    
    private func setupNavigationBar(){
        let doneBtn = UIButton()
        doneBtn.setTitle("완료", for: .normal)
        doneBtn.setTitleColor(UIColor(named: "primary-text"), for: .normal)
        doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBtn)
    }
    
    private func presentImagePickerController(sourceType: UIImagePickerController.SourceType){
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = sourceType
        imagePickerVC.delegate = self
        imagePickerVC.modalPresentationStyle = .fullScreen
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .systemBlue
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        
        self.present(imagePickerVC, animated: true)
    }
    
    @objc private func doneAction(){
        guard let currentUser = UserDefaultHelper.shared.getCurrentUser() else { return }
        
        let user = currentUser
        user.nickname = nicknameTF.text!
        user.name = nameTF.text
        user.intro = introTF.text
        
        SVProgressHUD.show()
        dismissKeyboard()
        userVM.updateUserDetail(user: user, profilePicture: selectedImage)
    }
}

extension EditProfileVC: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "현재 사진 삭제", style: .default, handler: {(action: UIAlertAction) in
            self.presentImagePickerController(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "사진 찍기", style: .default, handler: {(action: UIAlertAction) in
            self.presentImagePickerController(sourceType:.photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: {(action: UIAlertAction) in
            self.profilePictureIV.image = UIImage(named: "profile-placeholder-image")
            self.selectedImage = nil
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        navigationController?.navigationBar.tintColor = .black
        
        guard let image = info[.originalImage] as? UIImage else { return }
        selectedImage = image
        profilePictureIV.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        navigationController?.navigationBar.tintColor = .black
    }
}
