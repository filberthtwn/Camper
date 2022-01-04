//
//  AddFeedMenuVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 20/12/21.
//

import UIKit
import Photos

protocol AddFeedMenuDelegate {
    func didUpdateFrame(frameType: Int, color: UIColor)
}

class AddFeedMenuVC: UIViewController {

    @IBOutlet var feedsCV: UICollectionView!
    
    @IBOutlet var frameBtn: CamperViewButton!
    @IBOutlet var itemTagBtn: CamperViewButton!
    @IBOutlet var writeCommentBtn: CamperViewButton!
    
    @IBOutlet var feedsCL: UICollectionView!
    
    private var selectedIndex = 0
    private var selectedFrameType: Int = FrameType.NONE
    private var selectedFrameColor: UIColor = .clear
    
    var feeds: [PHAsset] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "side-menu-bg")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupViews(){
        frameBtn.delegate = self
        itemTagBtn.delegate = self
        writeCommentBtn.delegate = self
        
        feedsCV.contentOffset = CGPoint(x: 0, y: 0)
        feedsCV.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        feedsCV.register(UINib(nibName: "FeedMenuCVCell", bundle: nil), forCellWithReuseIdentifier: "FeedCell")
        
        setupNavBar()
    }
    
    private func setupNavBar(){
        setupTitle()
    
        let nextBtn = UIButton()
        nextBtn.setTitle("취소", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: nextBtn)
        
        navigationItem.showRightButton(target: self, title: "다음", do: #selector(nextAction))
    }
    
    private func setupTitle(){
        let titleL = UILabel()
        let attributedString1 = NSMutableAttributedString(string:"\(selectedIndex + 1)", attributes:[NSAttributedString.Key.foregroundColor: UIColor(named: "primary-text")!])
        let attributedString2 = NSMutableAttributedString(string:"/\(feeds.count)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedString1.append(attributedString2)
        titleL.attributedText = attributedString1
        navigationItem.titleView = titleL
    }
    
    @objc private func backAction(){
        let alert = UIAlertController(title: "피드 작성을 취소할까요?", message: "작성한 내용은 저장되지 않습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "계속 작성하기", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func nextAction(){
        let addFeedFormVC = AddFeedFormVC()
        addFeedFormVC.feeds = feeds
        navigationController?.pushViewController(addFeedFormVC, animated: true)
    }
}

extension AddFeedMenuVC: CamperButtonDelegate{
    func didButtonClicked(_ sender: CamperViewButton) {
        switch sender {
            case frameBtn:
                let selectFrameVC = SelectFrameVC()
                selectFrameVC.delegate = self
                selectFrameVC.selectedFrameType = selectedFrameType
                selectFrameVC.selectedColor = selectedFrameColor
                #warning("Need to Handle Last Selected Frame Rect")
                selectFrameVC.feedFrameRect = CGRect(x: 0, y: 0, width: 1, height: 1)
                selectFrameVC.lastFrame = feedsCL.frame
                selectFrameVC.feed = feeds[selectedIndex]
                selectFrameVC.modalTransitionStyle = .crossDissolve
                selectFrameVC.modalPresentationStyle = .fullScreen
                present(selectFrameVC, animated: true, completion: nil)
                break
            case itemTagBtn:
                let addItemTagVC = AddItemTagVC()
                addItemTagVC.feed = feeds[selectedIndex]
                addItemTagVC.modalTransitionStyle = .crossDissolve
                addItemTagVC.modalPresentationStyle = .fullScreen
                present(addItemTagVC, animated: true, completion: nil)
                break
            case writeCommentBtn:
                let addCommentVC = AddCommentVC()
                addCommentVC.modalTransitionStyle = .crossDissolve
                addCommentVC.modalPresentationStyle = .fullScreen
                present(addCommentVC, animated: true, completion: nil)
                break
            default:
                break
        }
    }
}

extension AddFeedMenuVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 896)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feed = feeds[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedMenuCVCell
        PHImageManager.default().requestImage(for: feed, targetSize: CGSize(width: view.frame.width, height: view.frame.height), contentMode: .aspectFill, options: nil) { image, info in
            cell.feedIV.image = image
        }
        cell.feedV.backgroundColor = selectedFrameColor
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectedIndex = Int((scrollView.contentOffset.x / feedsCV.frame.width))
        setupTitle()
    }
}

extension AddFeedMenuVC: AddFeedMenuDelegate {
    func didUpdateFrame(frameType: Int, color: UIColor) {
        selectedFrameType = frameType
        selectedFrameColor = color
        feedsCV.reloadData()
    }
}
