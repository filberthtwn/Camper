//
//  AlbumSelectVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 18/12/21.
//

import UIKit
import Photos

class AlbumSelectVC: UIViewController {

    @IBOutlet var albumTV: UITableView!
    
    var delegate: PhotoSelectDelegate?
    private var smartAlbums:[PHAssetCollection] = []
    private var albums:[PHAssetCollection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    private func setupViews(){
        title = "앨범선택"
        navigationItem.showDismissIcon()
        
        albumTV.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        albumTV.register(UINib(nibName: "AlbumTVCell", bundle: nil), forCellReuseIdentifier: "AlbumCell")
    }
    
    private func setupData(){
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        for i in 0..<smartAlbums.count {
            if smartAlbums[i].localizedTitle == "Favorites" || smartAlbums[i].localizedTitle == "Recents" {
                self.smartAlbums.append(smartAlbums[i])
            }
        }
        self.smartAlbums.reverse()
        
        let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        for i in 0..<albums.count {
            if albums[i].count > 0 {
                self.albums.append(albums[i])
            }
        }
    }
}

extension AlbumSelectVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }

        return 53
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: albumTV.frame.width, height: 53))
        let label = UILabel(frame: CGRect(x: 24, y: 16, width: albumTV.frame.width - 24, height: 21))
        label.text = "내 사진첩"
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return smartAlbums.count
        }
        return albums.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = indexPath.section == 0 ? smartAlbums[indexPath.item] : albums[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumTVCell

        cell.coverIV.image = UIImage()
        let fetchedAssets = PHAsset.fetchAssets(in: album, options: nil)
        if let coverAsset = fetchedAssets.lastObject {
            PHImageManager.default().requestImage(for: coverAsset, targetSize: CGSize(width: 75, height: 75), contentMode: .aspectFill, options: nil) { image, info in
                cell.coverIV.image = image
            }
        }
        cell.titleL.text = album.localizedTitle
        cell.countL.text = String(album.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = indexPath.section == 0 ? smartAlbums[indexPath.item] : albums[indexPath.item]
        delegate?.didSelectAlbum(title: album.localizedTitle ?? "", collection: album)
        dismiss(animated: true, completion: nil)
    }
}
