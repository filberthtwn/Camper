//
//  AddFeedFormVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 20/12/21.
//

import UIKit
import PanModal
import Photos

protocol AddFeedFormDelegate {
    func didCategorySelected(categories: [Category])
}

class AddFeedFormVC: UIViewController {
        
    @IBOutlet var addCategoryBtn: CamperViewButton!
    @IBOutlet var tagOthersBtn: CamperViewButton!
    @IBOutlet var tagLocationBtn: CamperViewButton!
    
    @IBOutlet var selectedCategoryV: UIView!
    @IBOutlet var taggedPeopleV: UIView!
    
    @IBOutlet var thumbnailCV: UICollectionView!
    
    @IBOutlet var categoryCV: UICollectionView!
    @IBOutlet var taggedPeopleCV: UICollectionView!
    
    @IBOutlet var contentTextV: UITextView!
    
    var feeds: [PHAsset] = []
    
    private var inset: CGFloat = 0
    private var cellWidthWithSpacing: CGFloat = 0
    private var selectedCategories: [Category] = []
    private var taggedPeople: [User] = []
    private var content: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupViews(){
        title = "새 게시물 작성"
        navigationItem.showRightButton(target: self, title: "업로드", do: #selector(uploadAction))
        
        addCategoryBtn.delegate = self
        tagOthersBtn.delegate = self
        tagLocationBtn.delegate = self
        
        contentTextV.tintColor = .clear
        contentTextV.textContainerInset = UIEdgeInsets(top: 0, left: -contentTextV.textContainer.lineFragmentPadding, bottom: 0, right: -contentTextV.textContainer.lineFragmentPadding)
        
        selectedCategoryV.isHidden = true
        taggedPeopleV.isHidden = true
        
        let width = thumbnailCV.frame.height * (view.frame.width/view.frame.height)
        let layout = (thumbnailCV.collectionViewLayout as! UICollectionViewFlowLayout)
        cellWidthWithSpacing = width + layout.minimumLineSpacing
        inset = (view.frame.width/2) - (width/2)
        thumbnailCV.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        thumbnailCV.register(UINib(nibName: "FeedsFormThumbnailCVCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailCell")
        
        categoryCV.register(UINib(nibName: "FeedFormItemCVCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        taggedPeopleCV.register(UINib(nibName: "FeedFormItemCVCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
    }
    
    private func presentAddCategoryVC(){
        let addCategoryVC = AddCategoryVC()
        addCategoryVC.delegate = self
        addCategoryVC.selectedCategories = selectedCategories
        addCategoryVC.height = view.frame.height * 0.65
        presentPanModal(addCategoryVC)
    }
    
    private func presentAddTagPeopleVC(){
        let addTaggedPeopleVC = AddTaggedPeopleVC()
        addTaggedPeopleVC.delegate = self
        addTaggedPeopleVC.users = taggedPeople
        
        let navVC = UINavigationController(rootViewController: addTaggedPeopleVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func addCategoryAction(_ sender: Any) {
        presentAddCategoryVC()
    }
    
    @IBAction func addTaggedPeopleAction(_ sender: Any) {
        presentAddTagPeopleVC()
    }
    
    @objc func uploadAction(){
        dismiss(animated: true, completion: nil)
    }
}

extension AddFeedFormVC: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {
        
        if sender == addCategoryBtn {
            presentAddCategoryVC()
            return
        }
        
        var viewController: UIViewController?
        switch sender {
        case tagOthersBtn:
            presentAddTagPeopleVC()
            break
        case tagLocationBtn:
            let addLocationVC = AddLocationVC()
            viewController = addLocationVC
            
            let navVC = UINavigationController(rootViewController: viewController!)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true, completion: nil)
            break
        default:
            break
        }
        
    }
}

extension AddFeedFormVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == thumbnailCV {
            let height = thumbnailCV.frame.height
            let scaleFactor = view.frame.width/view.frame.height
            let newWidth = height * scaleFactor
            return CGSize(width: newWidth, height: height)
        }
        return CGSize(width: 170, height: categoryCV.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == thumbnailCV {
            let index = round((targetContentOffset.pointee.x + scrollView.contentInset.left) / cellWidthWithSpacing)
            targetContentOffset.pointee = CGPoint(x: index * cellWidthWithSpacing - inset, y: scrollView.contentOffset.y)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case thumbnailCV:
            return feeds.count
        case categoryCV:
            return selectedCategories.count
        case taggedPeopleCV:
            return taggedPeople.count
        default:
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == thumbnailCV {
            let feed = feeds[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! FeedsFormThumbnailCVCell
            PHImageManager.default().requestImage(for: feed, targetSize: CGSize(width: view.frame.width, height: view.frame.height), contentMode: .aspectFill, options: nil) { image, info in
                cell.feedIV.image = image
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! FeedFormItemCVCell
        cell.delegate = self
        switch collectionView {
        case categoryCV:
            cell.configure(title: selectedCategories[indexPath.item].name,
                           index: indexPath.item,
                           type: .CATEGORY)
        case taggedPeopleCV:
            cell.configure(title: taggedPeople[indexPath.item].nickname,
                           index: indexPath.item,
                           type: .TAGGED_PEOPLE)
        default:
            break
        }
        return cell
    }
}

extension AddFeedFormVC: AddFeedFormDelegate {
    func didCategorySelected(categories: [Category]) {
        addCategoryBtn.isHidden = (categories.count != 0)
        selectedCategoryV.isHidden = (categories.count == 0)
        selectedCategories = categories
        categoryCV.reloadData()
    }
}

extension AddFeedFormVC: AddContentDelegate {
    func didContentUpdated(content: String) {
        self.content = content
        contentTextV.text = content.isEmpty ? "문구 입력.." : content
        contentTextV.textColor = content.isEmpty ? .placeholderText : .black
    }
}

extension AddFeedFormVC: FeedFormItemDelegate {
    func didRemoveItem(index: Int, type: FeedFormItem) {
        switch type {
        case .CATEGORY:
            selectedCategories.remove(at: index)
            categoryCV.reloadData()
            
            addCategoryBtn.isHidden = (selectedCategories.count != 0)
            selectedCategoryV.isHidden = (selectedCategories.count == 0)
            break
        case .TAGGED_PEOPLE:
            taggedPeople.remove(at: index)
            taggedPeopleCV.reloadData()
            
            tagOthersBtn.isHidden = (taggedPeople.count != 0)
            taggedPeopleV.isHidden = (taggedPeople.count == 0)
            break
        }
    }
}

extension AddFeedFormVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let addContentVC = AddContentsVC()
        addContentVC.delegate = self
        addContentVC.content = content
        let navVC = UINavigationController(rootViewController: addContentVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
}

extension AddFeedFormVC: AddTaggedPeopleDelegate {
    func didTaggedPeopleSelected(users: [User]) {
        taggedPeople = users
        taggedPeopleCV.reloadData()
        
        tagOthersBtn.isHidden = (taggedPeople.count != 0)
        taggedPeopleV.isHidden = (taggedPeople.count == 0)
    }
}
