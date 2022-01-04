//
//  PhotoSelectVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 18/12/21.
//

import UIKit
import Photos

protocol PhotoSelectDelegate {
    func didSelectAlbum(title: String, collection: PHAssetCollection)
}

class PhotoSelectVC: UIViewController {

    @IBOutlet var photoCL: UICollectionView!
    
    @IBOutlet var albumTitleL: UILabel!
    
    @IBOutlet var albumBtn: CamperViewButton!
    @IBOutlet var cameraBtn: CamperViewButton!
    
    private var photos = PHFetchResult<PHAsset>()
    private var selectedPhotos: [PHAsset] = []
    private let options = PHFetchOptions()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
        setupNavbar()
    }
    
    private func setupViews(){
        title = "사진선택"
        
        cameraBtn.delegate = self
        cameraBtn.layer.cornerRadius = cameraBtn.frame.height/2
        cameraBtn.layer.borderWidth = 2
        cameraBtn.layer.borderColor = UIColor.black.cgColor
        
        albumBtn.delegate = self
        
        photoCL.register(UINib(nibName: "PhotoCVCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
    private func setupNavbar(){
        navigationItem.showDismissIcon()
        navigationItem.showRightButton(target: self, title: "다음", do: #selector(nextAction))
    }
    
    private func setupData(){
        options.sortDescriptors = [
          NSSortDescriptor(
            key: "creationDate",
            ascending: false
          )
        ]
        photos = PHAsset.fetchAssets(with: options)
        
        if let firstImage = photos.firstObject {
            selectedPhotos.append(firstImage)
        }
    }
    
    private func presentImagePickerController(sourceType: UIImagePickerController.SourceType){
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = sourceType
        imagePickerVC.delegate = self
        imagePickerVC.modalPresentationStyle = .fullScreen
        
        self.present(imagePickerVC, animated: true)
    }
    
    @objc private func nextAction(){
        let addFeedMenuVC = AddFeedMenuVC()
        addFeedMenuVC.feeds = selectedPhotos
        navigationController?.pushViewController(addFeedMenuVC, animated: true)
    }
}

extension PhotoSelectVC: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {
        switch sender {
            case cameraBtn:
                presentImagePickerController(sourceType: .camera)
            case albumBtn:
                let albumSelectVC = AlbumSelectVC()
                albumSelectVC.delegate = self
                let navVC = UINavigationController(rootViewController: albumSelectVC)
                navVC.modalPresentationStyle = .fullScreen
                present(navVC, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension PhotoSelectVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        navigationController?.navigationBar.tintColor = .black

        guard let image = info[.originalImage] as? UIImage else { return }
//        selectedImage = image
//        profilePictureIV.image = selectedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        print("ABC")
        navigationController?.navigationBar.tintColor = .black
    }
}

extension PhotoSelectVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = selectedPhotos.firstIndex(where: { $0 == photos[indexPath.item]}){
            if selectedPhotos.count > 1 {
                selectedPhotos.remove(at: index)
            }
        }else{
            /// Maximum Selected Photos is 10
            if selectedPhotos.count < 10 {
                selectedPhotos.append(photos[indexPath.item])
            }
        }
        
        photoCL.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photoCL.frame.width/4 - 4, height: photoCL.frame.width/4 - 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photos[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCVCell
        
        PHImageManager.default().requestImage(for: photo, targetSize: CGSize(width: photoCL.frame.width/4 - 4, height: photoCL.frame.width/4 - 4), contentMode: .aspectFill, options: nil) { image, info in
            cell.photoIV.image = image
        }
        
        cell.selectedIndex = selectedPhotos.firstIndex(where: { $0 == photo })
        cell.isSelect = selectedPhotos.contains(where: { $0 == photo })
        return cell
    }
}

extension PhotoSelectVC: PhotoSelectDelegate{
    func didSelectAlbum(title: String, collection: PHAssetCollection) {
        selectedPhotos.removeAll()
        albumTitleL.text = title
        photos = PHAsset.fetchAssets(in: collection, options: options)
        if let firstImage = photos.firstObject {
            selectedPhotos.append(firstImage)
        }
        photoCL.reloadData()
    }
}
